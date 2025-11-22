# Índex
- [Índex](#índex)
- [Requeriments mínims del sistema](#requeriments-mínims-del-sistema)
- [Aplicacions recomanades](#aplicacions-recomanades)
- [Preparar-se i descarregar el codi font](#preparar-se-i-descarregar-el-codi-font)
    - [Un consell si el seu ordinador utilitza Windows](#un-consell-si-el-seu-ordinador-utilitza-windows)
- [Modificacions](#modificacions)
    - [Per protegir de les galetes (_cookies_)](#per-protegir-de-les-galetes-cookies)
    - [Per protegir d'altres mètodes d'identificació (_fingerprinting_, _DO NOT TRACK_, etc.) i desactivar la _prerenderització_ i la _preconnexió_](#per-protegir-daltres-mètodes-didentificació-fingerprinting-do-not-track-etc-i-desactivar-la-prerenderització-i-la-preconnexió)
    - [Per desactivar la _Privacy Sandbox_](#per-desactivar-la-privacy-sandbox)
    - [Per desactivar les mètriques d'ús i informes d'errors](#per-desactivar-les-mètriques-dús-i-informes-derrors)
    - [D'altres modificacions per fer la vida de l'usuari més agradable (_quality of live improvements_)](#daltres-modificacions-per-fer-la-vida-de-lusuari-més-agradable-quality-of-live-improvements)
    - [Interfície gràfica i personalització](#interfície-gràfica-i-personalització)
- [Compilació de Chromium](#compilació-de-chromium)
    - [Com crear un instal·lador interactiu](#com-crear-un-installador-interactiu)
- [Tests recomanats](#tests-recomanats)
    - [Del mateix projecte Chromium](#del-mateix-projecte-chromium)
    - [Referents a la privacitat](#referents-a-la-privacitat)
    - [Referents al rendiment](#referents-al-rendiment)

# Requeriments mínims del sistema
Siusplau, tingui present que aquests eren els requisits del sistema durant l'última actualització d'aquest README. Podria ser que haguessin canviat amb el temps.
* Un ordinador d'arquitectura x86-64 amb, com a mínim, 8 GB DE RAM. Es recomana tenir més de 16 GB de RAM, i tot i així el temps de compilació serà molt llarg. **Més de 64 GB no són excessives, així com una CPU amb més de 20 nuclis tampoc no és excessiva.**
* Com a mínim uns 100 GB d'espai lliure al disc dur (en podeu trobar una descripció més detallada a les instruccions del projecte Chromium per al vostre sistema operatiu). **Es recomana un SSD, preferiblement NVMe, per a un temps de descàrrega i compilació més petit.**
* Tenir Git instal·lat (o [Git per a Windows](https://gitforwindows.org/) si compilarà Nebula des d'un ordinador amb Windows).

# Aplicacions recomanades
* [Everything](https://www.voidtools.com/downloads/) (si compilarà el Projecte des d'un ordinador amb Windows), molt útil per a trobar fitxers específics en carpetes grans (com ara Chromium).
* [Visual Studio Code](https://code.visualstudio.com/Download), per a buscar cadenes de text específiques i modificar-les en bloc. 
* [MSYS2](https://www.msys2.org/) (si compilarà Nebula des d'un ordinador amb Windows), per a executar _scripts_ `.sh` (relacionats amb canvis d'icones o alguns tests).

# Preparar-se i descarregar el codi font

Llegeixi i segueixi les instruccions sobre com descarregar-se el codi per al seu sistema operatiu, recollides a [la documentació del projecte Chromium (en anglès)](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md).

### Un consell si el seu ordinador utilitza Windows
Si el seu ordinador utilitza Windows com a sistema operatiu, a l'hora d'instal·lar els complements de `Visual Studio` necessaris, pot fer-ho des d'una interfície gràfica: 
* Obri `Visual Studio Installer` (Si ja el té instal·lat. Si no, se'l pot descarregar [des d'aquest enllaç](https://visualstudio.microsoft.com/downloads/)).
* Vagi a la pestanya "**_Workloads_**" (o "**_Cargas de trabajo_**") i seleccioni "**_Desktop development with C++_**" (o "**_Desarrollo de escritorio con C++_**").Asseguri's que els subcomponents on es mencioni "**_MFC_**" i "**_ATL_**" estiguin seleccionats. Asseguri's també que els components on es mencioni "**_SDK_**" i **la seva versió del sistema operatiu** estiguin seleccionats.

Segueixi tots els passos per a configurar el seu sistema i descarregar-se el codi, fins a arribar a l'apartat `Setting up the build`.

# Modificacions
**Tot seguit, llistarem les modificacions a aplicar a al codi font de Chromium per a obtenir Nebula. Si només vol compilar Chromium, o si vol compilar Chromium abans d'aplicar les modificacions al codi font i recompilar-lo després, pot anar directament [a l'apartat corresponent d'aquest README](https://github.com/Isaac-Subirana/nebula/blob/main/README_CATAL%C3%80.md#compilaci%C3%B3-de-chromium).**

Les rutes on fer les modificacions que mencionarem són relatives a la ruta de descàrrega de Chromium. Si l'heu descarregat a la carpeta recomanada per la documentació del projecte Chromium, partirem sempre de `[EL TEU DISC]/src/chromium/src/`.

### Per protegir de les galetes (_cookies_)
1. Afegir a totes les galetes guardades l'atribut `samesite=strict`, per molt que s'intentin guardar amb valors diferents. 
   
   Podeu considerar si voleu que l'atribut aplicat sigui `samesite` o si considereu que amb `lax` n'hi ha prou per evitar les casuístiques que us interessi.
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

### Per protegir d'altres mètodes d'identificació (_fingerprinting_, _DO NOT TRACK_, etc.) i desactivar la _prerenderització_ i la _preconnexió_
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

3. Activar per defecte la sol·licitud "_DO NOT TRACK_", la protecció contra fingerprinting i la protecció  d'IP gestionades per la _Privacy Sandbox_, i bloquejar les galetes de tercers també en el mode B (un entorn alternatiu temporal dins de Chromium).
    
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


### Per desactivar la _Privacy Sandbox_

### Per desactivar les mètriques d'ús i informes d'errors
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

### D'altres modificacions per fer la vida de l'usuari més agradable (_quality of live improvements_)
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

### Interfície gràfica i personalització

1. Canviar el motor de cerca per defecte a Qwant (en lloc de Google). Pot canviar-lo per qualsevol altre simplement canviant el prefix abans del `.id` (per exemple, per posar DuckDuckGo, seria `duckduckgo.id`). Pot trobar una llista de els IDs a `third_party/search_engines_data/resources/definitions/prepopulated_engines.json`.
   
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


# Compilació de Chromium
Un cop dutes a terme les modificacions al codi font proposades, ja pot compilar el projecte, i obtindrà el navegador Nebula.

Per fer-ho, segueixi les instruccions proporcionades [al document referent al seu sistema operatiu](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md) des de l'apartat `Setting up the build`.

### Com crear un instal·lador interactiu
Si voleu crear un instal·lador interactiu per a utilitzar-lo en lloc del `mini_installer` proporcionat per el projecte Chromium, podeu fer-ho de la següent manera:

* Instal·leu-vos el programa [Inno Setup Compiler](https://jrsoftware.org/isdl.php).
* Compileu el `mini_installer` del Projecte:
  
  ```shell
  cd out/Default
  autoninja mini_installer
  ```

* Descarregeu-vos o copieu l'script [`UI_installer.iss`](https://github.com/Isaac-Subirana/nebula/blob/main/resources/UI_installer.iss) que podeu trobar a la carpeta `resources` d'aquest repositori.
* Compileu-lo utilitzant Inno Setup Compiler (tingueu en compte que heu de copiar el `mini_installer.exe` generat pel Projecte a la carpeta on us hagueu descarregat l'script).

Alternativament, també podeu crear vosaltres el vostre propi script i compilar-lo des del programa que més us agradi, i fer que extregui (o no) directament els fitxers del vostre navegador en lloc de ser una façana sobre el `mini_installer`.

# Tests recomanats
### Del mateix projecte Chromium
Recomanem utilitzar les utilitats `base_unittests` i `browser_tests`, que venen amb el codi font del navegador. Podem compilar-les amb la comanda següent:
```shell
cd out/Default
autoninja base_unittests && autoninja browser_tests
```
Després, només caldrà executar-los. Podeu trobar la documentació del Projecte referent a totes les seves utilitats de testeig [aquí](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/testing_in_chromium.md).

### Referents a la privacitat
* L'analitzador de privacitat de [Privacy.net](https://privacy.net/analyzer/).
* Els tests de [browserleaks.com](https://browserleaks.com) referents al [canvas](https://browserleaks.com/canvas) fingerprinting i al [WebGL](https://browserleaks.com/webgl) fingerprinting.
* Els tests de [webglreport.com](https://webglreport.com/?v=1) i [webgpureport.org](https://webgpureport.org/), referents també al fingerprinting.

### Referents al rendiment
Referents al rendiment, recomanem utilitzar els tres tests oferits per [browserbench.org](https://browserbench.org/):
* [Speedometer](https://browserbench.org/Speedometer3.1/), que s'utilitza per a mesurar la fluïdesa d'aplicacions web simples.
* [JetStream](https://browserbench.org/JetStream/), que s'utiltiza per a mesurar el rendiment del navegador executant codi JavaScript i WebAssembly (utilitzat normalment en aplicacions web complexes).
* [MotionMark](https://browserbench.org/MotionMark1.3.1/), que s'utilitza per a mesurar la capacitat d'un navegador per a animar escenes complexes.

Nota: en aquests tests, les puntuacions més altes són les millors.