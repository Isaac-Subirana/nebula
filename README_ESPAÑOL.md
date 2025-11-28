# Índice
- [Índice](#índice)
- [Descargarse el navegador Nebula](#descargarse-el-navegador-nebula)
- [Requisitos mínimos del sistema](#requisitos-mínimos-del-sistema)
- [Aplicaciones recomendadas](#aplicaciones-recomendadas)
- [Prepararse y descargar el código fuente](#prepararse-y-descargar-el-código-fuente)
    - [Un consejo si su ordenador utiliza Windows](#un-consejo-si-su-ordenador-utiliza-windows)
- [Modificaciones](#modificaciones)
    - [Para proteger de las _cookies_](#para-proteger-de-las-cookies)
    - [Para proteger de otros métodos de indentificación (_fingerprinting_, _DO NOT TRACK_, etc.) y desactivar la _prerenderización_ y la _preconnexión_](#para-proteger-de-otros-métodos-de-indentificación-fingerprinting-do-not-track-etc-y-desactivar-la-prerenderización-y-la-preconnexión)
- [A PARTIR DE AQUÍ, PENDIENTE DE TRADUCCIÓN](#a-partir-de-aquí-pendiente-de-traducción)
    - [Para desactivar la _Privacy Sandbox_](#para-desactivar-la-privacy-sandbox)
    - [Para desactivar las métricas de uso y informes de errores](#para-desactivar-las-métricas-de-uso-y-informes-de-errores)
    - [Otras modificaciones para hacer la vida del usuario más agradable (_quality of live improvements_)](#otras-modificaciones-para-hacer-la-vida-del-usuario-más-agradable-quality-of-live-improvements)
    - [Interfaz gráfica y personalización](#interfaz-gráfica-y-personalización)
- [Compilación de Chromium](#compilación-de-chromium)
    - [Argumentos de compilación recomendados](#argumentos-de-compilación-recomendados)
    - [Cómo crear un instalador interactivo](#cómo-crear-un-instalador-interactivo)
- [Test recomendados](#test-recomendados)
    - [Del mismo proyecto Chromium](#del-mismo-proyecto-chromium)
    - [Referentes a la privacidad](#referentes-a-la-privacidad)
    - [Referentes al rendimiento](#referentes-al-rendimiento)
  
# Descargarse el navegador Nebula

En este documento se detallan las instrucciones para compilar Nebula (o cualquier otro navegador basado en Chromium) desde zero con sus propios medios.

Para hacerlo, va a necesitar algunos conocimientos técnicos, predisposición para leer documentación en inglés, un ordenador medianamente potente y paciencia (o un ordenador cualquiera y MUCHA paciencia), y otros detalles que puede encontrar en la sección [Requerimentos mínimos del sistema](#requisitos-mínimos-del-sistema) de este mismo README.

Si lo que quiere es simplemente descargarse Nebula, puede hacerlo desde [este enlace](https://github.com/Isaac-Subirana/nebula/releases). Haga clic en `Nebula-Setup.exe`.

# Requisitos mínimos del sistema
Por favor, tenga en cuenta que estos eran los requisitos mínimos del sistema durante la última actualización de este README. Podría ser que hubiesen cambiado con el tiempo.
* Un ordenador de arquitectura x86-64 con, como mínimo, 8 GB de RAM. Se recomienda tener más de 16 GB de RAM, y aún así el tiempo de compilación será muy largo. **Más de 64 GB no son excesivos, así como una CPU con más de 20 núcleos tampoco es excesiva.**
* Como mínimo unos 100 GB de espacio libre en el disco duro (puede encontrar una descripción más detallada en las instrucciones del proyecto Chromium para su sistema operativo). **Se recomienda un SSD, a ser posible NVMe, para un tiempo de descarga y compilación más pequeño.**
* Tener Git instalado (o [Git para Windows](https://gitforwindows.org/)) si va a compilar Nebula desde un ordenador con Windows.

# Aplicaciones recomendadas
* [Everything](https://www.voidtools.com/es-es/descargas/) (si va a compilar el Proyecto desde un ordenador con Windows), muy útil para encontrar ficheros concretos en carpetas grandes (como la del proyecto Chromium).
* [Visual Studio Code](https://code.visualstudio.com/Download), para buscar cadenas de texto específicas y modificarlas en bloque. 
* [MSYS2](https://www.msys2.org/) (si compilará Nebula desde un ordenador con Windows), para ejecutar _scripts_ `.sh` (relacionados con canvios en los iconos y algunos test).

# Prepararse y descargar el código fuente

Lea y siga las instrucciones sobre cómo descargarse el código para su sistema operativo, que puede encontrar en [la documentación del proyecto Chromium (en inglés)](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md).

Siga todos los pasos para configurar su sistema y descargarse el código, hasta llegar al apartado `Setting up the build`.

### Un consejo si su ordenador utiliza Windows
Si su ordenador usa Windows como sistema operativo, puede instalar los complementos de `Visual Studio` necesarios desde una interfaz gráfica: 
* Abra `Visual Studio Installer` (Si ya lo tiene instalado. Si no, se lo puede descargar [des de este enlace](https://visualstudio.microsoft.com/downloads/)).
* Vaya a la pestaña "**_Workloads_**" (o "**_Cargas de trabajo_**") y seleccione "**_Desktop development with C++_**" (o "**_Desarrollo de escritorio con C++_**"). Asegúrese que los componentes que mencionen "**_MFC_**" y "**_ATL_**" estén seleccionados. Asegúrese también que los componentes que mencionen "**_SDK_**" y **su versión de sistema operativo** estén seleccionados.

# Modificaciones
**A continuación, ofrecemos un listado de las modificaciones a aplicar al código fuente de Chromium para obtener Nebula.**

**Si solo quiere compilar Chromium, o si quiere compilar Chromium antes de aplicar las modificaciones al código fuente y recompilarlo después, puede ir directamente [al apartado correspondiente de este README](#compilación-de-chromium)**.

Los caminos donde hacer las modificaciones que vamos a mencionar son relativas a la ruta de descarga de Chromium. Si lo ha descargado en la carpeta recomendada por la documentación del proyecto Chromium, siempre vamos a partir de `[SU DISCO]/src/chromium/src/`.

Todas las modificaciones que enumeraremos se deberían poder copiar y pegar directamente encima de la versión original, pero compruebe que la estructura del código sea igual a el original que proveemos nosotros. En algún caso en que copiar y pegar no sea posible (porque proveemos de diversos fragmentos a modificar en una misma caja de texto) avisamos de ello al principio de esa modificación.

### Para proteger de las _cookies_
1. Añadir a todas las _cookies_ que se guarden el atributo `samesite=strict`, aunque se intenten guardar con valores distintos. 
   
   Puede considerar si quiere que el atributo aplicado sea `strict` o si cree que con `lax` hay suficiente para evitar las casuísticas que le interesen.
    * **Archivo a modificar: `net/cookies/canonical_cookie.cc`**
    * **Código a modificar:**

        Sustitución de:

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

        Por:

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

2. Hacer que las _cookies_ de terceros esten bloqueadas por defecto en el modo de navegación tradicional, y no solo en el modo Incógnito.
    * **Archivo a modificar: `components/content_settings/core/browser/cookie_settings.cc`**
    * **Código a modificar:**

        Sustitución de:

        ```C++
        void CookieSettings::RegisterProfilePrefs(
            user_prefs::PrefRegistrySyncable* registry) {
            registry->RegisterIntegerPref(
                prefs::kCookieControlsMode,
                static_cast<int>(CookieControlsMode::kIncognitoOnly),
                user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        }
        ```

        Por:

        ```C++
        void CookieSettings::RegisterProfilePrefs(
            user_prefs::PrefRegistrySyncable* registry) {
            registry->RegisterIntegerPref(
                prefs::kCookieControlsMode,
                static_cast<int>(CookieControlsMode::kBlockThirdParty),
                user_prefs::PrefRegistrySyncable::SYNCABLE_PREF);
        }
        ```

### Para proteger de otros métodos de indentificación (_fingerprinting_, _DO NOT TRACK_, etc.) y desactivar la _prerenderización_ y la _preconnexión_
1. Activar la _flag_ (parámetro experimental) que añade _sonido_ al crear lienzos, para hacer el navegador menos reconoscible.

    Alternativamente, también se puede bloquear completamente el envío de _canvas_, buscando una sección de código similar dentro del mismo archivo, pero donde se mencione `kBlockCanvasReadback`, y aplicando las mismas modificaciones.
   
    * **Archivo a modificar: `components/fingerprinting_protection_filter/interventions/common/interventions_features.cc`**
    * **Código a modificar:**

        Sustitución de:

        ```C++
        BASE_FEATURE(kCanvasNoise, base::FeatureState::FEATURE_DISABLED_BY_DEFAULT);

        BASE_FEATURE_PARAM(bool,
                        kCanvasNoiseInRegularMode,
                        &kCanvasNoise,
                        "enable_in_regular_mode",
                        false);
        ```

        Por:

        ```C++
        BASE_FEATURE(kCanvasNoise, base::FeatureState::FEATURE_ENABLED_BY_DEFAULT);

        BASE_FEATURE_PARAM(bool,
                        kCanvasNoiseInRegularMode,
                        &kCanvasNoise,
                        "enable_in_regular_mode",
                        true);
        ```

2. Mentir a WebGL sobre el hardware del ordenador des del que se ejecute el navegador, para evitar el _fingerprinting_ mediante WebGL. 

    Puede igualmente modificar los valores falsos que le proporcionamos por cualesquiera otros que considere oportunos y creíbles.

    * **Archivos a modificar: `third_party/blink/renderer/modules/webgpu/gpu_adapter_info.cc` y `third_party/blink/renderer/modules/webgl/webgl_rendering_context_base.cc`**
    * **Código a modificar:**

        Dentro de `third_party/blink/renderer/modules/webgpu/gpu_adapter_info.cc`:

        Sustitución de:

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

        Por:

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

        Dentro de `third_party/blink/renderer/modules/webgl/webgl_rendering_context_base.cc`: 

        **Atención! No proveemos en este caso de código habilitado para copiar y pegar, tendrá que buscar individualmente cada componente que mencionamos y sustituirlo por la versión propuesta (o los valores que considere oportunos) manualmente!**

        Sustitución de:

        ```C++
        //Fragmento de código 1

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

        //Fragmento de código 2

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

        //Fragmento de código 3

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

        Por:
        
        ```C++
        //Fragmento de código 1

        case GL_SHADING_LANGUAGE_VERSION:
            if (IdentifiabilityStudySettings::Get()->ShouldSampleType(
                    blink::IdentifiableSurface::Type::kWebGLParameter)) {
                RecordIdentifiableGLParameterDigest(
                    pname, IdentifiabilityBenignStringToken(String("WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)")));
            }
            return WebGLAny(
                script_state,
                String("WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)"));

        //Fragmento de código 2

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

        //Fragmento de código 3
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

1. Activar por defecto la solicitud "_DO NOT TRACK_", la protección contra _fingerprinting_ y la protección de IP gestionados por la _Privacy Sandbox_, y bloquear las _cookies_ de terceros también el modo B (un entorno alternativo temporal dentro de Chromium).
    
    * **Archivo a modificar: `components/privacy_sandbox/tracking_protection_prefs.cc`**
    * **Código a modificar:**

        Sustitución de:

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

        Por:

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

4. Activar algunas intervenciones para frenar el _fingerprinting_ en el modo Incógnito, desactivar el _fallback_ de la _prerenderización_ a la _preconnexión_.

    * **Archivo a modificar: `chrome/common/chrome_features.cc `** 
    * **Código a modificar:**

        Sustitución de:

        ```C++
        BASE_FEATURE(kIncognitoFingerprintingInterventions,
             base::FEATURE_DISABLED_BY_DEFAULT);
        ```

        Por:

        ```C++
        BASE_FEATURE(kIncognitoFingerprintingInterventions,
             base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        Substitución también de:

        ```C++
        BASE_FEATURE(kPrerenderFallbackToPreconnect, base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        Por:

        ```C++
        BASE_FEATURE(kPrerenderFallbackToPreconnect, base::FEATURE_DISABLED_BY_DEFAULT);
        ```

5. Desactivar el _prefetch proxy_ de Chromium (el componente que lleva a cabo la preconnexión).
    
    * **Archivo a modificar: `content/public/common/content_features.cc`**
    * **Código a modificar:**
    
        Sustitución de:

        ```C++
        BASE_FEATURE(kPrefetchProxy, base::FEATURE_ENABLED_BY_DEFAULT);
        ```

        per:

        ```C++
        BASE_FEATURE(kPrefetchProxy, base::FEATURE_DISABLED_BY_DEFAULT);
        ```
   
6. Hacer que la _prerenderización_ no se active en redes lentas y cambiar los parámetros sobre la velocidad de red considerada lenta para que el navegador considere que cualquier red lo sea. 

    * **Archivo a modificar: `content/browser/preloading/prerender/prerender_features.cc`**
    * **Código a modificar:**
    
        Sustitución de:

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

        Por:

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
# A PARTIR DE AQUÍ, PENDIENTE DE TRADUCCIÓN
### Para desactivar la _Privacy Sandbox_
1. Desactivació de components de _Privacy Sanbox_ referents a l'agrupació de l'historial web en Temes (_Topics_) y als anuncis personalitzats, entre d'altres.
   
   * **Archivo a modificar: `components/privacy_sandbox/privacy_sandbox_features.cc`**
   * **Código a modificar:**
    
       **Atenció! No proveïm en aquest cas de  código habilitat per a copiar y enganxar, haureu de buscar individualment cada Fragmento de código y subsituir-lo manualment!**

        Sustitución de: 
        
        ```C++
        //Fragmento de código 1
        BASE_FEATURE(kPrivacySandboxSettings4, base::FEATURE_ENABLED_BY_DEFAULT);


        //Fragmento de código 2
        BASE_FEATURE(kEnforcePrivacySandboxAttestations,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragmento de código 3
        BASE_FEATURE(kPrivacySandboxActivityTypeStorage,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragmento de código 4
        BASE_FEATURE(kPrivacySandboxAdTopicsContentParity,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragmento de código 5
        BASE_FEATURE(kPrivacySandboxMigratePrefsToSchemaV2,
             base::FEATURE_ENABLED_BY_DEFAULT);

        //Fragmento de código 6
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

        Por:

        ```C++
        //Fragmento de código 1
        BASE_FEATURE(kPrivacySandboxSettings4, base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragmento de código 2
        BASE_FEATURE(kEnforcePrivacySandboxAttestations,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragmento de código 3
        BASE_FEATURE(kPrivacySandboxActivityTypeStorage,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragmento de código 4
        BASE_FEATURE(kPrivacySandboxAdTopicsContentParity,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragmento de código 5
        BASE_FEATURE(kPrivacySandboxMigratePrefsToSchemaV2,
             base::FEATURE_DISABLED_BY_DEFAULT);

        //Fragmento de código 6
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

### Para desactivar las métricas de uso y informes de errores
1. Desactivació de les mètriques d'ús.
   
    * **Archivo a modificar: `components/metrics/metrics_service.cc`**
    * **Código a modificar:**

        Sustitución de:

        ```C++
        void MetricsService::Start() {
        HandleIdleSinceLastTransmission(false);
        EnableRecording();
        EnableReporting();
        }
        ```

        Por:

        ```C++
        void MetricsService::Start() {
        //HandleIdleSinceLastTransmission(false);
        EnableRecording();
        DisableReporting();
        }
        ```

2. Desactivació de la possibilitat de l'enviament d'informes d'errors.

    * **Archivo a modificar: `chrome/app/chrome_crash_reporter_client_win.cc`** (variarà segons el sistema operatiu per al que volguem compilar el nostre navegador, però no tenim coneixiement sobre a quins fitxers se'n pot trobar la implementació).
    * **Código a modificar:**

        Sustitución de:

        ```C++
        bool ChromeCrashReporterClient::GetCollectStatsConsent() {
        return install_static::GetCollectStatsConsent();
        }
        bool ChromeCrashReporterClient::GetCollectStatsInSample() {
        return install_static::GetCollectStatsInSample();
        }
        ```

        Por:

        ```C++
        bool ChromeCrashReporterClient::GetCollectStatsConsent() {
        return false;
        }
        bool ChromeCrashReporterClient::GetCollectStatsInSample() {
        return false;
        }
        ```

### Otras modificaciones para hacer la vida del usuario más agradable (_quality of live improvements_)
1. Activar per defecte la _flag_ que permet les descàrregues paral·leles.
   
   * **Archivo a modificar: `components/download/public/common/download_features.cc`**
   * **Código a modificar:**

        Sustitución de:

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

        Por:

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
   
    * **Archivo a modificar: `media/base/media_switches.cc`**
    * **Código a modificar:**
  
        Sustitución de:

        ```C++
        BASE_FEATURE(kEnableTabMuting, base::FEATURE_DISABLED_BY_DEFAULT);
        ```

        Por:

        ```C++
        BASE_FEATURE(kEnableTabMuting, base::FEATURE_ENABLED_BY_DEFAULT);
        ``` 

### Interfaz gráfica y personalización

1. Canviar el motor de cerca per defecte a Qwant (en lloc de Google). Pot canviar-lo per qualsevol altre simplement canviant el prefix abans del `.id` (per exemple, per posar DuckDuckGo, seria `duckduckgo.id`). Pot trobar una llista dels IDs a `third_party/search_engines_data/resources/definitions/prepopulated_engines.json`.
   
   * **Archivo a modificar: `components/search_engines/template_url_prepopulate_data.cc`**
   * **Código a modificar:**
        
        Sustitución de:

        ```C++
        std::unique_ptr<TemplateURLData> GetPrepopulatedFallbackSearch(
        PrefService& prefs,
        std::vector<const TemplateURLPrepopulateData::PrepopulatedEngine*>
            regional_prepopulated_engines) {
        return FindPrepopulatedEngineInternal(prefs, regional_prepopulated_engines,
                                                google.id, /*use_first_as_fallback=*/true);
        }
        ```

        Por:

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

    * **Archivo a modificar: `chrome/browser/ui/startup/infobar_utils.cc`**
    * **Código a modificar:**
       
        Sustitución de:

        ```C++
        if (!google_apis::HasAPIKeyConfigured()) {
            GoogleApiKeysInfoBarDelegate::Create(infobar_manager);
        }
        ```

        Por:

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
        
        Dins d'aquests fitxers, substitueixi només les ocurrències de "Chrome" y "Chromium" que apareguin en cadenes de text amb l'atribut `translateable="false"`, com en el següent exemple:

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

        Perquè el nom es mostri correctament en tots els idiomes, s'han d'editar tots els fitxers `.xtb` dins de les carpetes `chrome/app/resources/` y `components/strings/`.

    * **Codi a modificar - per a les traduccions:**
        
        Substitueixi les referències a `Chromium` y `Chrome` (recomanem utilitzar Visual Studio Code per a buscar totes les ocurrències d'aquestes paraules dins dels fitxers y substituir-les directament) pel nom personalitzat del seu navegador. **Recordi activar la opció perquè la cerca y substitució distingeixi entre majúscules y minúscules, o podria ser que es trobi amb errors de compilació al modificar sense voler noms de variable.** 
        
        Un cop fet, si el vol fer públic, busqui també globalment `[El nom del seu navegador]OS` (per exemple, `NebulaOS`) y torni'l a substituir per `ChromeOS`, ja que amb la cerca anterior s'haurà fet aquest canvi indesitjat.

4. Canviar el logotip del navegador per un logotip personalitzat. 
   
    #### Si solo quiere utilizar el icono de Nebula

   Si només vol canviar el logotip de per defecte per el de Nebula, pot substituir directament els fitxers d'icones dins de `chrome/app/theme/chromium` y `chrome/app/theme/chromium/[la plataforma per a la qual compili]`. Nosaltres li proporcionem directament el fitxer `.ico` per a Windows, y els fitxers de la icona original en diverses mides y formats si el que vol és compilar el navegador per a una plataforma diferent.
   
    #### Si quiere utilizar un icono personalizado

   Si el que vol és utilitzar un logotip personalitzat, subsitueixi els logos de la carpeta `chrome/app/theme/chromium` y `chrome/app/theme/chromium/[la plataforma per a la qual compili]` per el seu.
   
    Si vol que els logos es mostrin correctament a Windows, segueixi [aquestes instruccions](https://github.com/chromium/chromium/blob/main/chrome/app/theme/README.md). 
    
    Per a poder executar `src/tools/resources/optimize-ico-files.py`, recomanat dins de les instruccions,  _**si està compilant Chromium des de Windows**_, ho haurà de fer utilitzant alguna eina que li permeti executar scripts `.sh` (scripts _bash_ de Linux). 
    
    Li recomanem utilitzar [MSYS2](https://www.msys2.org/) de la següent manera: 
       
    * Descarregui's els executables que trobarà dins `resources/logo/programs` en aquest mateix repositori a la carpeta `C:/src/tools`.
    * Substitueixi els `.ico` del projecte amb els seus.
    * Executi les següents comandes, seguides y sense reiniciar MSYS:
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
    
    * **Archivo a modificar: `chrome/app/theme/chromium/BRANDING`**
    * **Código a modificar:** 
        
        Substitueixi les referències al nom de la companyia, el nom del producte, etc., per les que desitgi que es mostrin a les propietats del fitxer y el llistat de programes instal·lats a Windows. **Tingui en compte que no pot utilitzar accents.**

# Compilación de Chromium
Un cop dutes a terme les modificacions al  código font proposades, ja pot compilar el projecte, y n'obtindrà el navegador Nebula.

Per fer-ho, segueixi les instruccions proporcionades [al document referent al seu sistema operatiu](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md) des de l'apartat `Setting up the build`.

### Argumentos de compilación recomendados
Per a una compilació més ràpida y un navegador perfectament funcional al final d'aquesta, li recomanem que utilitzi els arguments de compilació següents (també els pot trobar a `resources/` dins aquest repositori):

```shell
# Set build arguments here. See `gn help buildargs`.
is_debug=false
is_component_build=false
is_official_build=true
use_official_google_api_keys = false
symbol_level=0

#Set your operating system on the following arg. The options are "android", "chromeos", "ios", "linux", "nacl", "chromeos", "win" 
target_os="win"

use_allocator_shim=true
enable_hangout_services_extension=false
blink_symbol_level=0
v8_symbol_level=0
is_official_build=true
```

### Cómo crear un instalador interactivo
Si voleu crear un instal·lador interactiu per a utilitzar-lo en lloc del `mini_installer` proporcionat per el projecte Chromium, podeu fer-ho de la següent manera:

* Instal·leu-vos el programa [Inno Setup Compiler](https://jrsoftware.org/isdl.php).
* Compileu el `mini_installer` del Projecte:
  
  ```shell
  cd out/Default
  autoninja mini_installer
  ```

* Descarregeu-vos o copieu l'script [`UI_installer.iss`](https://github.com/Isaac-Subirana/nebula/blob/main/resources/UI_installer.iss) que podeu trobar a la carpeta `resources` d'aquest repositori.
* Compileu-lo utilitzant Inno Setup Compiler (tingueu en compte que heu de copiar el `mini_installer.exe` generat pel Projecte a la carpeta on us hagueu descarregat l'script).

Alternativament, també podeu crear vosaltres el vostre propi script y compilar-lo des del programa que més us agradi, y fer que extregui (o no) directament els fitxers del vostre navegador en lloc de ser una façana sobre el `mini_installer`.

# Test recomendados
### Del mismo proyecto Chromium
Recomanem utilitzar les utilitats `base_unittests` y `browser_tests`, que venen amb el  código font del navegador. Podem compilar-les amb la comanda següent:
```shell
cd out/Default
autoninja base_unittests && autoninja browser_tests
```
Després, només caldrà executar-los. Podeu trobar la documentació del Projecte referent a totes les seves utilitats de testeig [aquí](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/testing_in_chromium.md).

### Referentes a la privacidad
* L'analitzador de privacitat de [Privacy.net](https://privacy.net/analyzer/).
* Els tests de [browserleaks.com](https://browserleaks.com) referents al [canvas](https://browserleaks.com/canvas) fingerprinting y al [WebGL](https://browserleaks.com/webgl) fingerprinting.
* Els tests de [webglreport.com](https://webglreport.com/?v=1) y [webgpureport.org](https://webgpureport.org/), referents també al fingerprinting.

### Referentes al rendimiento
Referents al rendiment, recomanem utilitzar els tres tests oferits per [browserbench.org](https://browserbench.org/):
* [Speedometer](https://browserbench.org/Speedometer3.1/), que s'utilitza per a mesurar la fluïdesa d'aplicacions web simples.
* [JetStream](https://browserbench.org/JetStream/), que s'utiltiza per a mesurar el rendiment del navegador executant  código JavaScript y WebAssembly (utilitzat normalment en aplicacions web complexes).
* [MotionMark](https://browserbench.org/MotionMark1.3.1/), que s'utilitza per a mesurar la capacitat d'un navegador per a animar escenes complexes.

Nota: en aquests tests, les puntuacions més altes són les millors.