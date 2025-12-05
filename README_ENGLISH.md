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

Per a fer-ho, necessitarà alguns coneixements tècnics, predisposició per a llegir documentació en anglès, un ordinador mitjanament potent i paciència (o un ordinador qualsevol i MOLTA paciència), i d'altres detalls que pot trobar a la secció [Requeriments mínims del sistema](#requeriments-mínims-del-sistema) d'aquest mateix README. 

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

Totes les modificacions que enumerarem s'haurien de poder copiar i enganxar directament sobre la versió original, però comproveu que l'estructura del codi sigui igual a l'original que proveïm nosaltres. En algun cas en què copiar i enganxar no sigui possible (perquè proveïm de diversos fragments a modificar dins d'una mateixa caixa de text) n'avisem al principi de la modificació en concret.

### To protect from cookies
1. Afegir a totes les galetes guardades l'atribut `samesite=strict`, per molt que s'intentin guardar amb valors diferents. 
   
   Podeu considerar si voleu que l'atribut aplicat sigui `strict` o si considereu que amb `lax` n'hi ha prou per evitar les casuístiques que us interessi.
    * **Fitxer a modificar: `net/cookies/canonical_cookie.cc`**
    * **Codi a modificar:**

        Substitució de:

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

        Per:

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

2. Fer que les galetes de tercers estiguin bloquejades per defecte en el mode de navegació tradicional, i no només en el mode d'Incògnit.
    * **Fitxer a modificar: `components/content_settings/core/browser/cookie_settings.cc`**
    * **Codi a modificar:**

        Substitució de:

        ```C++
        void CookieSettings::RegisterProfilePrefs(
            user_prefs::PrefRegistrySyncable* registry) {
            registry->RegisterIntegerPref(
                prefs::kCookieControlsMode,
                static_cast<int>(CookieControlsMode::kIncognitoOnly),
                user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        }
        ```

        Per:

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
1. Activar la _flag_ (paràmetre experimental) que afegeix _soroll_ al generar llenços, per a fer el navegador menys reconeixible.

    Alternativament, també podeu bloquejar completament l'enviament de _canvas_, buscant una secció de codi similar dins del mateix fitxer, però on es mencioni `kBlockCanvasReadback`, i aplicant-hi les mateixes modificacions.
   
    * **Fitxer a modificar: `components/fingerprinting_protection_filter/interventions/common/interventions_features.cc`**
    * **Codi a modificar:**

        Substitució de:

        ```C++
        BASE_FEATURE(kCanvasNoise, base::FeatureState::FEATURE_DISABLED_BY_DEFAULT);

        BASE_FEATURE_PARAM(bool,
                        kCanvasNoiseInRegularMode,
                        &kCanvasNoise,
                        "enable_in_regular_mode",
                        false);
        ```

        Per:

        ```C++
        BASE_FEATURE(kCanvasNoise, base::FeatureState::FEATURE_ENABLED_BY_DEFAULT);

        BASE_FEATURE_PARAM(bool,
                        kCanvasNoiseInRegularMode,
                        &kCanvasNoise,
                        "enable_in_regular_mode",
                        true);
        ```
2. Mentir a WebGL sobre el hardware de l'ordinador des del qual s'executi el navegador, per a evitar el _fingerprinting_ a través de WebGL. 

    Podeu igualment modificar els valors falsos que li proporcionem per qualsevols altre que considereu oportuns i creïbles.

    * **Fitxers a modificar: `third_party/blink/renderer/modules/webgpu/gpu_adapter_info.cc` i
        `third_party/blink/renderer/modules/webgl/webgl_rendering_context_base.cc`**
    * **Codi a modificar:**

        Dins de `third_party/blink/renderer/modules/webgpu/gpu_adapter_info.cc`:

        Substitució de:

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

        Per:

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

        Dins de `third_party/blink/renderer/modules/webgl/webgl_rendering_context_base.cc`: 

        **Atenció! No proveïm en aquest cas de codi habilitat per a copiar i enganxar, haureu de buscar individualment cada component que mencionem i subsituir-lo per la versió que proposem (o els valors que considereu oportuns) manualment!**

        Substitució de:

        ```C++
        //Fragment de codi 1

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

        //Fragment de codi 2

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

        //Fragment de codi 3

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

        Per:
        
        ```C++
        //Fragment de codi 1

        case GL_SHADING_LANGUAGE_VERSION:
            if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                    blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(String("WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)")));
            }
            return WebGLAny(
                script_state,
                String("WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)"));

        //Fragment de codi 2

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

        //Fragment de codi 3
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

3. Activar per defecte la sol·licitud "_DO NOT TRACK_", la protecció contra fingerprinting i la protecció d'IP gestionades per la _Privacy Sandbox_, i bloquejar les galetes de tercers també en el mode B (un entorn alternatiu temporal dins de Chromium).
    
    * **Fitxer a modificar: `components/privacy_sandbox/tracking_protection_prefs.cc`**
    * **Codi a modificar:**

        Substitució de:

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

        Per:

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

4. Activar algunes intervencions per aturar el _fingerprinting_ en el mode d'Incògnit, desactivar el _fallback_ de la _prerenderització_ a la _preconnexió_.

    * **Fitxer a modificar: `chrome/common/chrome_features.cc `** 
    * **Codi a modificar:**

        Substitució de:

        ```C++
        BASE_FEATURE(kIncognitoFingerprintingInterventions,
             base::FEATURE_DISABLED_BY_DEFAULT);
        ```

        Per:

        ```C++
        BASE_FEATURE(kIncognitoFingerprintingInterventions,
             base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        Substitució també de:

        ```C++
        BASE_FEATURE(kPrerenderFallbackToPreconnect, base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        Per:

        ```C++
        BASE_FEATURE(kPrerenderFallbackToPreconnect, base::FEATURE_DISABLED_BY_DEFAULT);
        ```

5. Desactivar el _prefetch proxy_ de Chromium (el component que duu a terme la preconnexió).
    
    * **Fitxer a modificar: `content/public/common/content_features.cc`**
    * **Codi a modificar:**
    
        Substitució de:
        ```C++
        BASE_FEATURE(kPrefetchProxy, base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        per:

        ```C++
        BASE_FEATURE(kPrefetchProxy, base::FEATURE_DISABLED_BY_DEFAULT);
        ```
   
6. Fer que la _prerenderització_ no s'activi en xarxes lentes i canviar els paràmetres sobre la velocitat de xarxa considerada lenta perquè el navegador consideri que qualsevol xarxa ho és. 

    * **Fitxer a modificar: `content/browser/preloading/prerender/prerender_features.cc`**
    * **Codi a modificar:**
    
        Substitució de:

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

        Per:

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
1. Desactivació de components de _Privacy Sanbox_ referents a l'agrupació de l'historial web en Temes (_Topics_) i als anuncis personalitzats, entre d'altres.
   
   * **Fitxer a modificar: `components/privacy_sandbox/privacy_sandbox_features.cc`**
   * **Codi a modificar:**
    
       **Atenció! No proveïm en aquest cas de codi habilitat per a copiar i enganxar, haureu de buscar individualment cada fragment de codi i subsituir-lo manualment!**

        Substitució de: 
        
        ```C++
        //Fragment de codi 1
        BASE_FEATURE(kPrivacySandboxSettings4, base::FEATURE_ENABLED_BY_DEFAULT);


        //Fragment de codi 2
        BASE_FEATURE(kEnforcePrivacySandboxAttestations,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragment de codi 3
        BASE_FEATURE(kPrivacySandboxActivityTypeStorage,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragment de codi 4
        BASE_FEATURE(kPrivacySandboxAdTopicsContentParity,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragment de codi 5
        BASE_FEATURE(kPrivacySandboxMigratePrefsToSchemaV2,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragment de codi 6
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

        Per:

        ```C++
        //Fragment de codi 1
        BASE_FEATURE(kPrivacySandboxSettings4, base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragment de codi 2
        BASE_FEATURE(kEnforcePrivacySandboxAttestations,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragment de codi 3
        BASE_FEATURE(kPrivacySandboxActivityTypeStorage,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragment de codi 4
        BASE_FEATURE(kPrivacySandboxAdTopicsContentParity,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragment de codi 5
        BASE_FEATURE(kPrivacySandboxMigratePrefsToSchemaV2,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragment de codi 6
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
1. Desactivació de les mètriques d'ús.
   
    * **Fitxer a modificar: `components/metrics/metrics_service.cc`**
    * **Codi a modificar:**

        Substitució de:

        ```C++
        void MetricsService::Start() {
        HandleIdleSinceLastTransmission(false);
        EnableRecording();
        EnableReporting();
        }
        ```

        Per:

        ```C++
        void MetricsService::Start() {
        //HandleIdleSinceLastTransmission(false);
        EnableRecording();
        DisableReporting();
        }
        ```

2. Desactivació de la possibilitat de l'enviament d'informes d'errors.

    * **Fitxer a modificar: `chrome/app/chrome_crash_reporter_client_win.cc`** (variarà segons el sistema operatiu per al que volguem compilar el nostre navegador, però no tenim coneixiement sobre a quins fitxers se'n pot trobar la implementació).
    * **Codi a modificar:**

        Substitució de:

        ```C++
        bool ChromeCrashReporterClient::GetCollectStatsConsent() {
        return install_static::GetCollectStatsConsent();
        }
        bool ChromeCrashReporterClient::GetCollectStatsInSample() {
        return install_static::GetCollectStatsInSample();
        }
        ```

        Per:

        ```C++
        bool ChromeCrashReporterClient::GetCollectStatsConsent() {
        return false;
        }
        bool ChromeCrashReporterClient::GetCollectStatsInSample() {
        return false;
        }
        ```

### Quality of live improvements
1. Activar per defecte la _flag_ que permet les descàrregues paral·leles.
   
   * **Fitxer a modificar: `components/download/public/common/download_features.cc`**
   * **Codi a modificar:**

        Substitució de:

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

        Per:

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
2. Activar per defecte la _flag_ que permet silenciar una pestanya que estigui reproduint àudio des de la visualització mateixa de les pestanyes.
   
    * **Fitxer a modificar: `media/base/media_switches.cc`**
    * **Codi a modificar:**
  
        Substitució de:

        ```C++
        BASE_FEATURE(kEnableTabMuting, base::FEATURE_DISABLED_BY_DEFAULT);
        ```

        Per:

        ```C++
        BASE_FEATURE(kEnableTabMuting, base::FEATURE_ENABLED_BY_DEFAULT);
        ``` 

### Graphical interface and personalization

1. Canviar el motor de cerca per defecte a Qwant (en lloc de Google). Pot canviar-lo per qualsevol altre simplement canviant el prefix abans del `.id` (per exemple, per posar DuckDuckGo, seria `duckduckgo.id`). Pot trobar una llista dels IDs a `third_party/search_engines_data/resources/definitions/prepopulated_engines.json`.
   
   * **Fitxer a modificar: `components/search_engines/template_url_prepopulate_data.cc`**
   * **Codi a modificar:**
        
        Substitució de:

        ```C++
        std::unique_ptr<TemplateURLData> GetPrepopulatedFallbackSearch(
        PrefService& prefs,
        std::vector<const TemplateURLPrepopulateData::PrepopulatedEngine*>
            regional_prepopulated_engines) {
        return FindPrepopulatedEngineInternal(prefs, regional_prepopulated_engines,
                                                google.id, /*use_first_as_fallback=*/true);
        }
        ```

        Per:

        ```C++
        std::unique_ptr<TemplateURLData> GetPrepopulatedFallbackSearch(
        PrefService& prefs,
        std::vector<const TemplateURLPrepopulateData::PrepopulatedEngine*>
            regional_prepopulated_engines) {
        return FindPrepopulatedEngineInternal(prefs, regional_prepopulated_engines,
                                                qwant.id, /*use_first_as_fallback=*/true);
        }
        ```

2. Desactivar el missatge flotant "Falten algunes claus d'API de Google"  que apareix per defecte cada vegada que s'inicia el navegador. 

    Si vostè ho considera oportú, pot fer servir claus d'API de Google per a obtenir accés a serveis com ara el Traductor de Google integrat al navegador, o la sincronització de preferències. [Aquí](https://www.chromium.org/developers/how-tos/api-keys/) pot trobar les instruccions per utilitzar-ne. Nosaltres, en aquest cas, no ho vam considerar necessari.

    * **Fitxer a modificar: `chrome/browser/ui/startup/infobar_utils.cc`**
    * **Codi a modificar:**
       
        Substitució de:

        ```C++
        if (!google_apis::HasAPIKeyConfigured()) {
            GoogleApiKeysInfoBarDelegate::Create(infobar_manager);
        }
        ```

        Per:

        ```C++
        /*if (!google_apis::HasAPIKeyConfigured()) {
            GoogleApiKeysInfoBarDelegate::Create(infobar_manager);
        }*/
        ```

3. Personalitzar les cadenes de text del navegador (el nom que apareix a la interfície gràfica).
   
    * **Fitxers a modificar - per a les frases de referència:**
    
        * `chrome/app/chromium_strings.grd`
        * `chrome/app/google_chrome_strings.grd`
        * `chrome/app/settings_strings.grdp`
        * `chrome/app/settings_chromium_strings.grdp`
        * `chrome/app/settings_google_chrome_strings.grdp`
        * `components/components_chromium_strings.grd`
    
    * **Codi a modificar - per a les frases de referència:**
        
        Dins d'aquests fitxers, substitueixi només les ocurrències de "Chrome" i "Chromium" que apareguin en cadenes de text amb l'atribut `translateable="false"`, com en el següent exemple:

        ```xml
        <message name="IDS_PRODUCT_NAME" desc="The Chrome application name" translateable="false">
            Chromium
          </message>
        ```
        Aquest exemple mencionat hauríem de substituir-lo per:

        ```xml
        <message name="IDS_PRODUCT_NAME" desc="The Chrome application name" translateable="false">
            [El nom del vostre navegador]
          </message>
        ```

    * **Fitxers a modificar - per a les traduccions:**

        Perquè el nom es mostri correctament en tots els idiomes, s'han d'editar tots els fitxers `.xtb` dins de les carpetes `chrome/app/resources/` i `components/strings/`.

    * **Codi a modificar - per a les traduccions:**
        
        Substitueixi les referències a `Chromium` i `Chrome` (recomanem utilitzar Visual Studio Code per a buscar totes les ocurrències d'aquestes paraules dins dels fitxers i substituir-les directament) pel nom personalitzat del seu navegador. **Recordi activar la opció perquè la cerca i substitució distingeixi entre majúscules i minúscules, o podria ser que es trobi amb errors de compilació al modificar sense voler noms de variable.** 
        
        Un cop fet, si el vol fer públic, busqui també globalment `[El nom del seu navegador]OS` (per exemple, `NebulaOS`) i torni'l a substituir per `ChromeOS`, ja que amb la cerca anterior s'haurà fet aquest canvi indesitjat.

4. Canviar la icona del navegador per una de personalitzada. 
   
    #### Si només vol utilitzar la icona de Nebula

   Si només vol canviar la icona per defecte per la de Nebula, pot substituir directament els fitxers de logotips dins de `chrome/app/theme/chromium` i `chrome/app/theme/chromium/[la plataforma per a la qual compili]`. Nosaltres li proporcionem directament el fitxer `.ico` per a Windows, i els fitxers de la icona original en diverses mides i formats si el que vol és compilar el navegador per a una plataforma diferent.
   
    #### Si vol utilitzar una icona personalitzada

   Si el que vol és utilitzar una icona personalitzada, subsitueixi els logos de la carpeta `chrome/app/theme/chromium` i `chrome/app/theme/chromium/[la plataforma per a la qual compili]` per el seu.
   
    Si vol que les icones es mostrin correctament a Windows, segueixi [aquestes instruccions](https://github.com/chromium/chromium/blob/main/chrome/app/theme/README.md). 
    
    Per a poder executar `src/tools/resources/optimize-ico-files.py`, recomanat dins de les instruccions,  _**si està compilant Chromium des de Windows**_, ho haurà de fer utilitzant alguna eina que li permeti executar scripts `.sh` (scripts _bash_ de Linux). 
    
    Li recomanem utilitzar [MSYS2](https://www.msys2.org/) de la següent manera: 
       
    * Descarregui's els executables que trobarà dins `resources/logo/programs` en aquest mateix repositori a la carpeta `C:/src/tools`.
    * Substitueixi els `.ico` del projecte amb els seus.
    * Executi les següents comandes, seguides i sense reiniciar MSYS:
        ```bash
        pacman -S mingw-w64-x86_64-advancecomp mingw-w64-x86_64-libpng mingw-w64-x86_64-optipng
        
        export PATH="/mingw64/bin:$PATH"
        export PATH="/c/src/tools:$PATH"

        cd /c/src/chromium/src
        python tools/resources/optimize-ico-files.py chrome/app/theme/chromium/win/chromium.ico 
        # Executar aquesta última comanda amb les diverses rutes dels .ico a comprovar.
        ```
        
        L'_output_ de l'última comanda hauria de ser semblant al següent:

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

5. Canviar el fitxer de BRANDING del navegador.
    
    * **Fitxer a modificar: `chrome/app/theme/chromium/BRANDING`**
    * **Codi a modificar:** 
        
        Substitueixi les referències al nom de la companyia, el nom del producte, etc., per les que desitgi que es mostrin a les propietats del fitxer i el llistat de programes instal·lats a Windows. **Tingui en compte que no pot utilitzar accents.**

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

#Set your target OS in the following argument. The available options are: "android", "chromeos", "ios", "linux", "nacl", "chromeos", "win" 
target_os="win"

use_allocator_shim=true
enable_hangout_services_extension=false
blink_symbol_level=0
v8_symbol_level=0
is_official_build=true
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