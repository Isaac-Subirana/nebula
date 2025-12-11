# Table of Contents
- [Table of Contents](#table-of-contents)
- [Downloading the Nebula browser](#downloading-the-nebula-browser)
- [Minimum system requirements](#minimum-system-requirements)
- [Recommended apps](#recommended-apps)
- [Getting everything ready and downloading the source code](#getting-everything-ready-and-downloading-the-source-code)
    - [A quick tip if you're on Windows](#a-quick-tip-if-youre-on-windows)
- [Modifications](#modifications)
    - [To protect from cookies](#to-protect-from-cookies)
    - [To protect from other identification methods (fingerprinting, DO NOT TRACK, etc.) and to disable preconnection and prerendering](#to-protect-from-other-identification-methods-fingerprinting-do-not-track-etc-and-to-disable-preconnection-and-prerendering)
    - [To disable Privacy Sandbox](#to-disable-privacy-sandbox)
    - [To disable telemetry and failure reports](#to-disable-telemetry-and-failure-reports)
    - [Quality of live improvements](#quality-of-live-improvements)
    - [Graphical interface and personalization](#graphical-interface-and-personalization)
- [Compiling Chromium](#compiling-chromium)
    - [Recommended build arguments](#recommended-build-arguments)
    - [How to create an interactive installer](#how-to-create-an-interactive-installer)
- [Recommended tests](#recommended-tests)
    - [Chromium project's tests](#chromium-projects-tests)
    - [Privacy tests](#privacy-tests)
    - [Performance tests (benchmarks)](#performance-tests-benchmarks)
  
# Downloading the Nebula browser

In this document we provide the instrucutions to compile Nebula (or any other Chromium-based browser) from scratch, using your own means.

To do so, you are going to need some technichal knowledge, predisposition to read documentation, a medium-end or high-end PC and patience (or any PC and A LOT of patience), and some other details you are going to find in this README's section [Minimum system requirements](#minimum-system-requirements).

If you wanted to simply download and install the Nebula browser, you can do it from [this link](https://github.com/Isaac-Subirana/nebula/releases) by clicking over the first occurrence of `Nebula-Setup.exe` you see.

# Minimum system requirements
Keep in mind these were the system requirements at the time of these README's last update. They may vary over time.
* An x86-64 machine with at least 8 GB of RAM. More than 16 GB are recommended, and the compilation time will still be really long. **64+ GB are not excessive. 20+ CPU cores are not excessive either.**
* At least 100GB of free disk space (you can find a more accurate description in each operating system's Chromium instructions). **An SSD is recommended, preferably an NVMe drive, to improve download and compilation times.**
* Git (or [Git for Windows](https://gitforwindows.org/) if you're on Windows) installed.

# Recommended apps
* [Everything](https://www.voidtools.com/downloads/) (if you're on Windows), very useful for finding specific files in large folders (such as the Chromium project's folder).
* [Visual Studio Code](https://code.visualstudio.com/Download), to search for specific project strings and bulk-modifying these. 
* [MSYS2](https://www.msys2.org/) (if you're on Windows), to run `.sh` scripts (related to icon modification and some tests).

# Getting everything ready and downloading the source code

Please, read and follow the instructions about how to donwload Chromium's source for your operating system, which you can find in [Chromium project's documentation](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md).

Go trough all of the steps to set up your system and to download the source code, up until the `Setting up the build` section.

### A quick tip if you're on Windows
If your computer uses Windows, you can use a graphical interface to install the needed `Visual Studio` accessories: 
* Open the `Visual Studio Installer` app (if you already have Visual Studio installed. If you don't, you can download it from [this link](https://visualstudio.microsoft.com/downloads/)).
* Go to the "**_Workloads_**" tab and select "**_Desktop development with C++_**". Make sure that all of the assets mentioning "**_MFC_**" and "**_ATL_**" are selected, as well as the assets mentioning "**_SDK_**" and **your operating system's version**.

# Modifications
**In this section, we offer a list of all of the modifications that turn Chromium's source code into Nebula's source code.**

**If you only want to compile Chromium, or you want to compile Chromium before editing the source code and recompile it after, you can go directly [to this README's corresponding section](#compiling-chromium).**

The modification paths that we are going to mention are relative to the path were you have downloaded Chromium. If you have downloaded it in the folder that the Chromium project's documentation recommends, we will be starting from `[YOUR DISK]/src/chromium/src`.

All of the modifications that we are going to list should be copy-and-paste (over the original code) ready, but please make sure that the code structure is the same as the original we provide. In some cases where copy-and-pasting is not possible (as we provide with different code snippets that should be modified in a same text box) we will tell you in that specific modification's beginning.

### To protect from cookies
1. Adding the `samesite = strict` attribute to all of the saved cookies, even if they specify different `samesite` values. 
   
   You can consider if you want the applied attribute to be `strict` or whether you think `lax` is enough to stop the cases that concern you.
    * **File to modify: `net/cookies/canonical_cookie.cc`**
    * **Code to modify:**

        Replace:

        ```C++
        switch (cookie.SameSite()) {
            case CookieSameSite::NO_RESTRICTION:
                cookie_line += "; samesite=none";
                break;
            case CookieSameSite::LAX_MODE:
                cookie_line += "; samesite=lax";
                break;
            case CookieSameSite::STRICT_MODE:
                cookie_line += "; samesite=strict";
                break;
            case CookieSameSite::UNSPECIFIED:
                // Don't append any text if the samesite attribute wasn't explicitly set.
                break;
        }
        ```

        With:

        ```C++
        switch (cookie.SameSite()) {
            case CookieSameSite::NO_RESTRICTION:
                cookie_line += "; samesite=strict";
                break;
            case CookieSameSite::LAX_MODE:
                cookie_line += "; samesite=strict";
                break;
            case CookieSameSite::STRICT_MODE:
                cookie_line += "; samesite=strict";
                break;
            case CookieSameSite::UNSPECIFIED:
                cookie_line += "; samesite=strict";
                break;
        }
        ```

2. Blocking by default third-party cookies in all browsing modes and not only Incognito.
    * **File to modify: `components/content_settings/core/browser/cookie_settings.cc`**
    * **Code to modify:**

        Replace:

        ```C++
        void CookieSettings::RegisterProfilePrefs(
            user_prefs::PrefRegistrySyncable* registry) {
            registry->RegisterIntegerPref(
                prefs::kCookieControlsMode,
                static_cast<int>(CookieControlsMode::kIncognitoOnly),
                user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        }
        ```

        With:

        ```C++
        void CookieSettings::RegisterProfilePrefs(
            user_prefs::PrefRegistrySyncable* registry) {
            registry->RegisterIntegerPref(
                prefs::kCookieControlsMode,
                static_cast<int>(CookieControlsMode::kBlockThirdParty),
                user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        }
        ```

### To protect from other identification methods (fingerprinting, DO NOT TRACK, etc.) and to disable preconnection and prerendering
1. Activating a _flag_ (experimental feature) which adds _noise_ to the generated canvas, to make browser tracing more difficult.

    Alternativelly, you can also completely block the sending of _canvas_, searching for a code section similar inside this same file, where `kBlockCanvasReadback` is mentioned, and applying the same modifications there.
   
    * **File to modify: `components/fingerprinting_protection_filter/interventions/common/interventions_features.cc`**
    * **Code to modify:**

        Replace:

        ```C++
        BASE_FEATURE(kCanvasNoise, base::FeatureState::FEATURE_DISABLED_BY_DEFAULT);

        BASE_FEATURE_PARAM(bool,
                        kCanvasNoiseInRegularMode,
                        &kCanvasNoise,
                        "enable_in_regular_mode",
                        false);
        ```

        With:

        ```C++
        BASE_FEATURE(kCanvasNoise, base::FeatureState::FEATURE_ENABLED_BY_DEFAULT);

        BASE_FEATURE_PARAM(bool,
                        kCanvasNoiseInRegularMode,
                        &kCanvasNoise,
                        "enable_in_regular_mode",
                        true);
        ```
2. Lying to WebGL about the client computer's hardware, to avoid WebGL _fingerprinting_. 

    You can modify this values to whichever you think fit and are credible instead of the values we suggest.

    * **Files to modify: `third_party/blink/renderer/modules/webgpu/gpu_adapter_info.cc` i
        `third_party/blink/renderer/modules/webgl/webgl_rendering_context_base.cc`**
    * **Code to modify:**

        Inside of `third_party/blink/renderer/modules/webgpu/gpu_adapter_info.cc`:

        Replace:

        ```C++
        : vendor_(vendor),
          architecture_(architecture),
          subgroup_min_size_(subgroup_min_size),
          subgroup_max_size_(subgroup_max_size),
          is_fallback_adapter_(is_fallback_adapter),
          device_(device),
          description_(description),
          driver_(driver),
          backend_(backend),
          type_(type),
          d3d_shader_model_(d3d_shader_model),
          vk_driver_version_(vk_driver_version),
          power_preference_(power_preference) {}
        ```

        With:

        ```C++
        : vendor_("Intel Inc."),
          architecture_("Gen12"),
          subgroup_min_size_(subgroup_min_size),
          subgroup_max_size_(subgroup_max_size),
          is_fallback_adapter_(false),
          device_("Intel(R) Iris(R) Xe Graphics"),
          description_("Intel(R) Iris(R) Xe Graphics"),
          driver_("31.0.101.4502"),
          backend_("d3d12"),
          type_("integrated"),
          d3d_shader_model_(d3d_shader_model),
          vk_driver_version_(vk_driver_version),
          power_preference_(power_preference) {}
        ```

        Inside of `third_party/blink/renderer/modules/webgl/webgl_rendering_context_base.cc`: 

        **Warning! We do not provide, in this case, of copy-and-paste ready code, so you will need to search individually for each listed code snippet and manually replace it with your preferred "false" hardware.**

        Replace:

        ```C++
        //Code snippet #1

        case GL_SHADING_LANGUAGE_VERSION:
            if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                    blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(String(
                            ContextGL()->GetString(GL_SHADING_LANGUAGE_VERSION))));
            }
            return WebGLAny(
                script_state,
                "WebGL GLSL ES 1.0 (" +
                    String(ContextGL()->GetString(GL_SHADING_LANGUAGE_VERSION)) +
                    ")");

        //Code snippet #2

        case GL_VERSION:
            if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                    blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(
                            String(ContextGL()->GetString(GL_VERSION))));
            }
            return WebGLAny(
                script_state,
                "WebGL 1.0 (" + String(ContextGL()->GetString(GL_VERSION)) + ")");

        //Code snippet #3

        case WebGLDebugRendererInfo::kUnmaskedRendererWebgl:
            if (ExtensionEnabled(kWebGLDebugRendererInfoName)) {
                if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                        blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(
                                String(ContextGL()->GetString(GL_RENDERER))));
                }
                return WebGLAny(script_state,
                                String(ContextGL()->GetString(GL_RENDERER)));
            }
            SynthesizeGLError(
                GL_INVALID_ENUM, "getParameter",
                "invalid parameter name, WEBGL_debug_renderer_info not enabled");
            return ScriptValue::CreateNull(script_state->GetIsolate());
        case WebGLDebugRendererInfo::kUnmaskedVendorWebgl:
            if (ExtensionEnabled(kWebGLDebugRendererInfoName)) {
                if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                        blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(
                                String(ContextGL()->GetString(GL_VENDOR))));
                }
                return WebGLAny(script_state,
                                String(ContextGL()->GetString(GL_VENDOR)));
            }
            SynthesizeGLError(
                GL_INVALID_ENUM, "getParameter",
                "invalid parameter name, WEBGL_debug_renderer_info not enabled");
        ```

        With:
        
        ```C++
        //Code snippet #1

        case GL_SHADING_LANGUAGE_VERSION:
            if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                    blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(String("WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)")));
            }
            return WebGLAny(
                script_state,
                String("WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)"));

        //Code snippet #2

        case GL_VERSION:
            if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                    blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(
                            String("WebGL 1.0 (OpenGL ES 2.0 Chromium)")));
            }
            return WebGLAny(
                script_state,
                String("WebGL 1.0 (OpenGL ES 2.0 Chromium)"));

        //Code snippet #3
        case WebGLDebugRendererInfo::kUnmaskedRendererWebgl:
            if (ExtensionEnabled(kWebGLDebugRendererInfoName)) {
                if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                        blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(
                                String("ANGLE (Intel, Intel(R) Iris(R) Xe Graphics (0x0000A7A1) Direct3D11 vs_5_0 ps_5_0, D3D11)")));
                }
                return WebGLAny(script_state,
                                String("ANGLE (Intel, Intel(R) Iris(R) Xe Graphics (0x0000A7A1) Direct3D11 vs_5_0 ps_5_0, D3D11)"));
            }
            SynthesizeGLError(
                GL_INVALID_ENUM, "getParameter",
                "invalid parameter name, WEBGL_debug_renderer_info not enabled");
            return ScriptValue::CreateNull(script_state->GetIsolate());
        case WebGLDebugRendererInfo::kUnmaskedVendorWebgl:
            if (ExtensionEnabled(kWebGLDebugRendererInfoName)) {
                if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                        blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(
                                String("Google Inc. (Intel)")));
                }
                return WebGLAny(script_state,
                                String("Google Inc. (Intel)"));
            }
            SynthesizeGLError(
                GL_INVALID_ENUM, "getParameter",
                "invalid parameter name, WEBGL_debug_renderer_info not enabled");
        ```

3. Activate by default the "_DO NOT TRACK_" request sending, the fingerprinting and IP protection provided by the _Privacy Sandbox_. Block third-party cookies in Mode B (an alternative temporary development environment inside of Chromium) too. 
    
    * **File to modify: `components/privacy_sandbox/tracking_protection_prefs.cc`**
    * **Code to modify:**

        Replace:

        ```C++
        registry->RegisterBooleanPref(
            prefs::kEnableDoNotTrack, false,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        registry->RegisterBooleanPref(
            prefs::kFingerprintingProtectionEnabled, false,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        registry->RegisterBooleanPref(
            prefs::kIpProtectionEnabled, false,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);


        // TODO(https://b/333527273): The following prefs should be deprecated.
        // Still in use for Mode B.
        registry->RegisterBooleanPref(
            prefs::kBlockAll3pcToggleEnabled, false,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        registry->RegisterBooleanPref(prefs::kTrackingProtection3pcdEnabled, false);
        ```

        With:

        ```C++
        registry->RegisterBooleanPref(
            prefs::kEnableDoNotTrack, true,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        registry->RegisterBooleanPref(
            prefs::kFingerprintingProtectionEnabled, true,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        registry->RegisterBooleanPref(
            prefs::kIpProtectionEnabled, true,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);


        // TODO(https://b/333527273): The following prefs should be deprecated.
        // Still in use for Mode B.
        registry->RegisterBooleanPref(
            prefs::kBlockAll3pcToggleEnabled, true,
            user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        registry->RegisterBooleanPref(prefs::kTrackingProtection3pcdEnabled, true);
        ```

4. Activate some interventions to stop _fingerprinting_ in Incognito mode, deactivate _prerendering_'s fallback to _preconnection_.

    * **File to modify: `chrome/common/chrome_features.cc `** 
    * **Code to modify:**

        Replace:

        ```C++
        BASE_FEATURE(kIncognitoFingerprintingInterventions,
             base::FEATURE_DISABLED_BY_DEFAULT);
        ```

        With:

        ```C++
        BASE_FEATURE(kIncognitoFingerprintingInterventions,
             base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        Also, replace:

        ```C++
        BASE_FEATURE(kPrerenderFallbackToPreconnect, base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        With:

        ```C++
        BASE_FEATURE(kPrerenderFallbackToPreconnect, base::FEATURE_DISABLED_BY_DEFAULT);
        ```

5. Deactivate Chromium's _prefetch proxy_ (the component which performs the preconnection).
    
    * **File to modify: `content/public/common/content_features.cc`**
    * **Code to modify:**
    
        Replace:
        ```C++
        BASE_FEATURE(kPrefetchProxy, base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        With:

        ```C++
        BASE_FEATURE(kPrefetchProxy, base::FEATURE_DISABLED_BY_DEFAULT);
        ```
   
6. Change _prerendering_ so that it does not activate in slow networks, and then change the slow network parameters so that any network is considered to be "slow".
    * **File to modify: `content/browser/preloading/prerender/prerender_features.cc`**
    * **Code to modify:**
    
        Replace:

        ```C++
        BASE_FEATURE(kSuppressesPrerenderingOnSlowNetwork,
                base::FEATURE_DISABLED_BY_DEFAULT);

        // Regarding how this number was chosen, see the design doc linked from
        // crbug.com/350519234.
        const base::FeatureParam<base::TimeDelta>
            kSuppressesPrerenderingOnSlowNetworkThreshold{
                &kSuppressesPrerenderingOnSlowNetwork,
                "slow_network_threshold_for_prerendering", base::Milliseconds(208)};
        ```

        With:

        ```C++
        BASE_FEATURE(kSuppressesPrerenderingOnSlowNetwork,
                base::FEATURE_ENABLED_BY_DEFAULT);

        // Regarding how this number was chosen, see the design doc linked from
        // crbug.com/350519234.
        const base::FeatureParam<base::TimeDelta>
            kSuppressesPrerenderingOnSlowNetworkThreshold{
                &kSuppressesPrerenderingOnSlowNetwork,
                "slow_network_threshold_for_prerendering", base::Milliseconds(1)};
        ```

### To disable Privacy Sandbox
1. Deactivate some _Privacy Sanbox_ features, referring to the grouping of web history in _Topics_ and personalized ads, among others.
   
   * **File to modify: `components/privacy_sandbox/privacy_sandbox_features.cc`**
   * **Code to modify:**
    
       **Warning! We do not provide, in this case, of copy-and-paste ready code, so you will need to search individually for each listed code snippet and manually replace it!**

        Replace:
        
        ```C++
        //Code snippet #1
        BASE_FEATURE(kPrivacySandboxSettings4, base::FEATURE_ENABLED_BY_DEFAULT);


        //Code snippet #2
        BASE_FEATURE(kEnforcePrivacySandboxAttestations,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Code snippet #3
        BASE_FEATURE(kPrivacySandboxActivityTypeStorage,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Code snippet #4
        BASE_FEATURE(kPrivacySandboxAdTopicsContentParity,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Code snippet #5
        BASE_FEATURE(kPrivacySandboxMigratePrefsToSchemaV2,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Code snippet #6
        const char kPrivacySandboxActivityTypeStorageLastNLaunchesName[] =
            "last-n-launches";

        const base::FeatureParam<int> kPrivacySandboxActivityTypeStorageLastNLaunches{
            &kPrivacySandboxActivityTypeStorage,
            kPrivacySandboxActivityTypeStorageLastNLaunchesName, 100};

        const char kPrivacySandboxActivityTypeStorageWithinXDaysName[] =
            "within-x-days";

        const base::FeatureParam<int> kPrivacySandboxActivityTypeStorageWithinXDays{
            &kPrivacySandboxActivityTypeStorage,
            kPrivacySandboxActivityTypeStorageWithinXDaysName, 60};
        ```

        With:

        ```C++
        //Code snippet #1
        BASE_FEATURE(kPrivacySandboxSettings4, base::FEATURE_DISABLED_BY_DEFAULT);

        //Code snippet #2
        BASE_FEATURE(kEnforcePrivacySandboxAttestations,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Code snippet #3
        BASE_FEATURE(kPrivacySandboxActivityTypeStorage,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Code snippet #4
        BASE_FEATURE(kPrivacySandboxAdTopicsContentParity,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Code snippet #5
        BASE_FEATURE(kPrivacySandboxMigratePrefsToSchemaV2,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Code snippet #6
        const char kPrivacySandboxActivityTypeStorageLastNLaunchesName[] =
        "last-n-launches";

        const base::FeatureParam<int> kPrivacySandboxActivityTypeStorageLastNLaunches{
            &kPrivacySandboxActivityTypeStorage,
            kPrivacySandboxActivityTypeStorageLastNLaunchesName, 1};

        const char kPrivacySandboxActivityTypeStorageWithinXDaysName[] =
            "within-x-days";

        const base::FeatureParam<int> kPrivacySandboxActivityTypeStorageWithinXDays{
            &kPrivacySandboxActivityTypeStorage,
            kPrivacySandboxActivityTypeStorageWithinXDaysName, 1};
        ```

### To disable telemetry and failure reports
1. Disabling usage metrics.
   
    * **File to modify: `components/metrics/metrics_service.cc`**
    * **Code to modify:**

        Replace:

        ```C++
        void MetricsService::Start() {
        HandleIdleSinceLastTransmission(false);
        EnableRecording();
        EnableReporting();
        }
        ```

        With:

        ```C++
        void MetricsService::Start() {
        //HandleIdleSinceLastTransmission(false);
        EnableRecording();
        DisableReporting();
        }
        ```

2. Disabling the possiblity of sending error logs.

    * **File to modify: `chrome/app/chrome_crash_reporter_client_win.cc`** (it will change depending on your browser's target operating system, but we don't know in which files you can find its implementation for other operating systems).
    * **Code to modify:**

        Replace:

        ```C++
        bool ChromeCrashReporterClient::GetCollectStatsConsent() {
        return install_static::GetCollectStatsConsent();
        }
        bool ChromeCrashReporterClient::GetCollectStatsInSample() {
        return install_static::GetCollectStatsInSample();
        }
        ```

        With:

        ```C++
        bool ChromeCrashReporterClient::GetCollectStatsConsent() {
        return false;
        }
        bool ChromeCrashReporterClient::GetCollectStatsInSample() {
        return false;
        }
        ```

### Quality of live improvements
1. Activate, by default, the _flag_ that allows for parallel downloading.
   
   * **File to modify: `components/download/public/common/download_features.cc`**
   * **Code to modify:**

        Replace:

        ```C++
        BASE_FEATURE(kParallelDownloading,
             "ParallelDownloading",
        #if BUILDFLAG(IS_ANDROID)
                    base::FEATURE_ENABLED_BY_DEFAULT
        #else
                    base::FEATURE_DISABLED_BY_DEFAULT
        #endif
        );
        ```

        With:

        ```C++
        BASE_FEATURE(kParallelDownloading,
             "ParallelDownloading",
        #if BUILDFLAG(IS_ANDROID)
                    base::FEATURE_ENABLED_BY_DEFAULT
        #else
                    base::FEATURE_ENABLED_BY_DEFAULT
        #endif
        );
        ```
2. Activating, by default, the _flag_ which allows to mute a media-reproducing tab from the tab strip.
   
    * **File to modify: `media/base/media_switches.cc`**
    * **Code to modify:**
  
        Replace:

        ```C++
        BASE_FEATURE(kEnableTabMuting, base::FEATURE_DISABLED_BY_DEFAULT);
        ```

        With:

        ```C++
        BASE_FEATURE(kEnableTabMuting, base::FEATURE_ENABLED_BY_DEFAULT);
        ``` 

### Graphical interface and personalization

1. Changing the default search engine to Qwant (instead of Google). You can change it to your preferred search engine by simply changing the prefix before `.id` (as an example, to use DuckDuckGo, it would be `duckduckgo.id`). You can find a list of all of the available IDs in `third_party/search_engines_data/resources/definitions/prepopulated_engines.json`.
   
   * **File to modify: `components/search_engines/template_url_prepopulate_data.cc`**
   * **Code to modify:**
        
        Replace:

        ```C++
        std::unique_ptr<TemplateURLData> GetPrepopulatedFallbackSearch(
        PrefService& prefs,
        std::vector<const TemplateURLPrepopulateData::PrepopulatedEngine*>
            regional_prepopulated_engines) {
        return FindPrepopulatedEngineInternal(prefs, regional_prepopulated_engines,
                                                google.id, /*use_first_as_fallback=*/true);
        }
        ```

        With:

        ```C++
        std::unique_ptr<TemplateURLData> GetPrepopulatedFallbackSearch(
        PrefService& prefs,
        std::vector<const TemplateURLPrepopulateData::PrepopulatedEngine*>
            regional_prepopulated_engines) {
        return FindPrepopulatedEngineInternal(prefs, regional_prepopulated_engines,
                                                qwant.id, /*use_first_as_fallback=*/true);
        }
        ```

2. Deactivating the message "There are some Google API keys missing" which appears by default every time the browser is opened.

    If you find it necessary, you can use Google API keys to be able to use some extra services, such as the integrated Google Translate service, or preference sinchronization. You can find the instructions on how to do so [here](https://www.chromium.org/developers/how-tos/api-keys/).

    * **File to modify: `chrome/browser/ui/startup/infobar_utils.cc`**
    * **Code to modify:**
       
        Replace:

        ```C++
        if (!google_apis::HasAPIKeyConfigured()) {
            GoogleApiKeysInfoBarDelegate::Create(infobar_manager);
        }
        ```

        With:

        ```C++
        /*if (!google_apis::HasAPIKeyConfigured()) {
            GoogleApiKeysInfoBarDelegate::Create(infobar_manager);
        }*/
        ```

3. Personalize the browser text strings (the graphical interface messages).
   
    * **Files to modify - for the base strings:**
    
        * `chrome/app/chromium_strings.grd`
        * `chrome/app/google_chrome_strings.grd`
        * `chrome/app/settings_strings.grdp`
        * `chrome/app/settings_chromium_strings.grdp`
        * `chrome/app/settings_google_chrome_strings.grdp`
        * `components/components_chromium_strings.grd`
    
    * **Code to modify - for the base strings:**
        
        Inside of these files, replace only the "Chrome" and "Chromium" occurrences that apear in strings with the attribute `translateable="false"`, such as the following example:

        ```xml
        <message name="IDS_PRODUCT_NAME" desc="The Chrome application name" translateable="false">
            Chromium
          </message>
        ```
        This example should be replaced with:

        ```xml
        <message name="IDS_PRODUCT_NAME" desc="The Chrome application name" translateable="false">
            [Your browser's name]
          </message>
        ```

    * **Files to modify - for the translations:**

        To correctly show the name in all languages, all of the `.xtb` files inside the folders `chrome/app/resources/` and `components/strings/` should be edited.

    * **Code to modify - for the translations:**
        
        Replace the references to `Chromium` and/or `Chrome` (we recommend using Visual Studio Code to search all occurrences of these words inside the files and replacing them directly) with your browser's personalized name. **Remember to activate the case-sensitive search-and-replace, or else you might encounter compilation errors as you could have involuntarily modified variable names.** 
        
        Once you have done this, if you want to make your browser public, globally search for `[Your browser name]OS` too (for example, `NebulaOS`) and cange it back to `ChromeOS`, as with the previous replacement this unwanted change will have taken place.

4. Changing the default browser's icon for a personalized one.
   
    #### If you want to use Nebula's icon

   If you only want to change Chromium's default icon for Nebula's, you can directly replace the logo files inside `chrome/app/theme/chromium` and `chrome/app/theme/chromium/[your target platform]`. We provide you directly with the `.ico` file for Windows, and the original icon files in various sizes and formats if you want to compile the browser for a different platform.

    #### If you want to use a personalized icon

   If you want to use a personalized icon, replace the logos in the folders `chrome/app/theme/chromium` and `chrome/app/theme/chromium/[your target platform]` with yours.
   
    If you want your icons to show correctly in Windows, follow [these instructions](https://github.com/chromium/chromium/blob/main/chrome/app/theme/README.md). 
    
    To be able to run `src/tools/resources/optimize-ico-files.py`, recommended inside the provided instructions,  _**if you are compiling Chromium on Windows**_, you will need to do so using some app that allows you to run `.sh` scripts (Linux _bash_ scripts). 
    
    We recommend you using [MSYS2](https://www.msys2.org/) in the following way: 
       
    * Download the executables you will find inside `resources/logo/programs` in this repository to `C:/src/tools`.
    * Replace the project's `.ico` files with yours.
    * Run the following commands, one after another and without restarting MSYS:
        ```bash
        pacman -S mingw-w64-x86_64-advancecomp mingw-w64-x86_64-libpng mingw-w64-x86_64-optipng
        
        export PATH="/mingw64/bin:$PATH"
        export PATH="/c/src/tools:$PATH"

        cd /c/src/chromium/src
        python tools/resources/optimize-ico-files.py chrome/app/theme/chromium/win/chromium.ico 
        # Run this last command with the several paths of the .ico to check.
        ```
        
        The output of this last command should be similar to:

        ```
        INFO: chromium.ico entry #1: 16x16, 1128 bytes (BMP)
        INFO: chromium.ico entry #2: 16x16, 1384 bytes (BMP)
        INFO: chromium.ico entry #3: 256x256, 71768 bytes (PNG)
        Optimized 1/1 files in 00:00:23s
        Result: 71768 => 60935 bytes (10833 bytes: 15%)
        INFO: chromium.ico entry #4: 32x32, 4264 bytes (BMP)
        INFO: chromium.ico entry #5: 32x32, 2216 bytes (BMP)
        INFO: chromium.ico entry #6: 48x48, 9640 bytes (BMP)
        INFO: chromium.ico entry #7: 48x48, 3752 bytes (BMP)
        INFO: chrome/app/theme/chromium/win/chromium.ico : 94270 => 83437 (10833 bytes : 11 %)
        ```

5. Modifying the browser's BRANDING file.
    
    * **File to modify: `chrome/app/theme/chromium/BRANDING`**
    * **Code to modify:** 
        
        Replace all of the references to the company name, the product name, etc., with the ones you want to be shown on the executables' properties and on Windows' installed software list. **Please note that you can not use special characters (such as `, ´, ^, ¨...).**

# Compiling Chromium
Once all of the modifications of the source code have been completed, you can compile the project to get the Nebula browser.

To do so, follow the instructions given by [the document referring to your operating system](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md) from the section `Setting up the build` onwards.

### Recommended build arguments
For a faster compilation and a fully functional browser when it ends, we recommend you to use the following build arguments  (which you can also find in `resources/`, in this same repo):

```shell
# Set build arguments here. See `gn help buildargs`.
is_debug=false
is_component_build=false
is_official_build=true
use_official_google_api_keys = false
symbol_level=0

#Set your target OS in the following argument. The available options are: "android", "chromeos", "ios", "linux", "nacl" (deprecated), "win" 
target_os="win"

use_allocator_shim=true
enable_hangout_services_extension=false
blink_symbol_level=0
v8_symbol_level=0
```

To be able to use this arguments correctly, you will need to edit `[YOUR DISK]/src/chromium/.gclient`too, and in the following section

```
"custom_vars": {
    },
```
add

```
"custom_vars": {
      "checkout_pgo_profiles": True,
    },
```

To save this changes, you will then need to run the following command:

```shell
gclient runhooks
```

### How to create an interactive installer
If you want to create an interactive installer for Windows, instead of Chromium's `mini_installer`, you can do it following this instructions:

* Install the program [Inno Setup Compiler](https://jrsoftware.org/isdl.php).
* Compile the Project's `mini_installer`:
  
  ```shell
  cd out/Default
  autoninja mini_installer
  ```

* Download or copy the script [`UI_installer.iss`](https://github.com/Isaac-Subirana/nebula/blob/main/resources/UI_installer.iss) that you can find in `resources/` in this same repository.
* Compile it using Inno Setup Compiler (please note that you will have to copy the Project's `mini_installer.exe` in the folder where you have downloaded the script).

Alternativelly, you can also create your own script and compile it from your preferred installer compiler; and leave it as a facade over `mini_installer.exe` or make it extract directly your browser's files.

# Recommended tests
### Chromium project's tests
We recommend to use the `base_unittests` and `browser_tests` utilities that come already with the browser's source code. We can compile them like this:
```shell
cd out/Default
autoninja base_unittests && autoninja browser_tests
```
Once they have finished compiling we only have to run them. You can find the Project's documentation referring to all of their testing utilities [here](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/testing_in_chromium.md).

### Privacy tests
* The privacy analizer from [Privacy.net](https://privacy.net/analyzer/).
* [browserleaks.com](https://browserleaks.com)'s tests referring to [canvas](https://browserleaks.com/canvas) fingerprinting and [WebGL](https://browserleaks.com/webgl) fingerprinting.
* [webglreport.com](https://webglreport.com/?v=1)'s and [webgpureport.org](https://webgpureport.org/)'s tests, referring to WebGL fingerprinting too.

### Performance tests (benchmarks)
To measure the browser's performance, we recommend using [browserbench.org](https://browserbench.org/)'s tests:
* [Speedometer](https://browserbench.org/Speedometer3.1/), which measures simple web Applications' responsiveness.
* [JetStream](https://browserbench.org/JetStream/), which measures JavaScript and WebAssembly (used in more advanced web apps) responsiveness.
* [MotionMark](https://browserbench.org/MotionMark1.3.1/), which measures a browser's capability for animating complex scenes.

Note that in this tests, bigger scores mean better performance.