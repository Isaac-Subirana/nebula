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

**_Nota: hemos observado que en algunas de las versiones más nuevas de Chromium no se pueden aplicar algunas de las modificaciones que propondremos, ya que los ficheros que las gestionaban han sido modificados o eliminados._**

**_Para descargar el código fuente original de Chromium versión 143.0.7450.0, en la que se basa la última publicación de Nebula, puede hacerlo si se descarga el código fuente de Chromium como detallan las instrucciones del Proyecto (sin la flag `--no-history`) y después ejecuta el siguiente comando:_**
```bash
    cd src && git checkout d0c2c9dd4cbcee9b5d17f258fe55e40fa8e3c0e9
```
**_Una vez hecho podrá seguir las instrucciones de este README sin tener que omitir modificaciones._**

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

        **¡Atención! ¡No proveemos en este caso de código habilitado para copiar y pegar, tendrá que buscar individualmente cada componente que mencionamos y sustituirlo por la versión propuesta (o los valores que considere oportunos) manualmente!**

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

### Para desactivar la _Privacy Sandbox_
1. Desactivación de componentes de _Privacy Sanbox_ referentes a la agrupación del historial web en Temas (_Topics_) y a los anuncios personalitzados, entre otros.
   
   * **Archivo a modificar: `components/privacy_sandbox/privacy_sandbox_features.cc`**
   * **Código a modificar:**
      
        **¡Atención! ¡No proveemos en este caso de código habilitado para copiar y pegar, tendrá que buscar individualmente cada fragmento de código y sustituirlo manualmente!**

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
1. Desactivación de las métricas de uso.
   
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

2. Desactivación de la posibilidad de envío de informes de errores.

    * **Archivo a modificar: `chrome/app/chrome_crash_reporter_client_win.cc`** (cambiará según el sisteam operativo para el que quiera compilar su navegador, pero no tenemos conocimiento sobre en qué archivos se puede encontrar su implementación).
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
1. Activar por defecto la _flag_ que permite las descargas en paralelo.
   
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
2. Activar por defecto la _flag_ que permite silenciar una pestaña que esté reproduciendo audio desde la visualicazión misma de las pestañas.
   
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

1. Cambiar el motor de búsqueda por defecto a Qwant (en vez de Google). Puede sustitiuirlo por cualquier otro simplemente cambiando el prefijo antes del `.id` (por ejemplo, para usar DuckDuckGo, sería `duckduckgo.id`). Puede encontrar una lista de los IDs en `third_party/search_engines_data/resources/definitions/prepopulated_engines.json`.
   
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

2. Desactivar el mensaje flotante "Faltan algunes llaves de API de Google" que aparece por defecto cada vez que se inicia el navegador. 

    Si usted lo considera oportuno, puede usar llaves de API de Google para obtener acceso a servicios como el Traductor de Google integrado en el navegador, o la sincronización de preferencias. [Aquí](https://www.chromium.org/developers/how-tos/api-keys/) puede encontrar las instrucciones para usarlas.

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

3. Personalizar las cadenas de texto del navegador (el nombre que aparece en la interfaz gráfica).
   
    * **Archivos a modificar - para las frases de referencia:**
    
        * `chrome/app/chromium_strings.grd`
        * `chrome/app/google_chrome_strings.grd`
        * `chrome/app/settings_strings.grdp`
        * `chrome/app/settings_chromium_strings.grdp`
        * `chrome/app/settings_google_chrome_strings.grdp`
        * `components/components_chromium_strings.grd`
    
    * **Código a modificar - para las frases de referencia:**
        
        Dentro de estos archivos, sustituya solo las ocurrencias de "Chrome" y "Chromium" que aparezcan en cadenas de texto con el atributo `translateable="false"`, como en el siguiente ejemplo:

        ```xml
        <message name="IDS_PRODUCT_NAME" desc="The Chrome application name" translateable="false">
            Chromium
          </message>
        ```
        Este ejemplo mencionado debería ser sustituido con:

        ```xml
        <message name="IDS_PRODUCT_NAME" desc="The Chrome application name" translateable="false">
            [El nombre de su navegador]
          </message>
        ```

    * **Archivos a modificar - para las traducciones:**

        Para que el nombre se muestre correctamente en todos los idiomas, se deben editar todos los archivos `.xtb` dentro de las carpetas `chrome/app/resources/` y `components/strings/`.

    * **Código a modificar - para las traducciones:**
        
        Sustituya las referencias a `Chromium` y `Chrome` (recomendamos utilizar Visual Studio Code para buscar todas las ocurrencias de estas palabras dentro de los archivos y sustituirlas directamente) por el nombre personalizado de su navegador. **Recuerde activar la opción para que la búsqueda y sustitución distinga entre mayúsculas y minúsculas, o podría encontrarse con errores de compilación al cambiar sin querer nombres de variable.** 
        
        Una vez hecho, si lo quiere publicar, busque también globalmente en estas mismas ubicaciones `[El nombre de su navegador]OS` (por ejemplo, `NebulaOS`) y vuelva a sustituirlo por `ChromeOS`, ya que con la búsqueda anterior se habrá realizado este cambio indeseado.

4. Cambiar el icono del navegador por un icono personalitzado. 
   
    #### Si solo quiere utilizar el icono de Nebula

   Si només vol canviar el logotip de per defecte per el de Nebula, pot substituir directament els fitxers d'icones dins de `chrome/app/theme/chromium` y `chrome/app/theme/chromium/[la plataforma per a la qual compili]`. Nosaltres li proporcionem directament el fitxer `.ico` per a Windows, y els fitxers de la icona original en diverses mides y formats si el que vol és compilar el navegador per a una plataforma diferent.

   Si sol quiere cambiar el icono de Chromium por el de Nebula, puede sustituir directamente los ficheros del logotipo en `chrome/app/theme/chromium` y `chrome/app/theme/chromium/[la plataforma per a la qual compili]`. Nosotros le proporcionamos directamente el archivo `.ico` para Windows, y los ficheros de nuestro icono en diversos tamaños y formatos si lo que quiere es compilar el navegador para una plataforma distinta.
   
    #### Si quiere utilizar un icono personalizado

   Si lo que quiere es usar un icono personalizado, sustitya los iconos de la carpeta `chrome/app/theme/chromium` y `chrome/app/theme/chromium/[la plataforma para la que compile]` por el suyo.
   
    Si quiere que los iconos se muestren correctamente en Windows, siga [estas instrucciones](https://github.com/chromium/chromium/blob/main/chrome/app/theme/README.md). 
    
    Per a poder ejecutar `src/tools/resources/optimize-ico-files.py`, recomendado en las instrucciones, _**si está compilando Chromium en Windows**_, deberá hacerlo utilizando alguna herramienta que le permita ejecutar scripts `.sh` (scripts _bash_ de Linux). 
    
    Le recomendamos usar [MSYS2](https://www.msys2.org/) de la siguiente manera:
       
    * Descárguese los ejecutables que encontrará en `resources/logo/programs` en este mismo repostiorio, en la carpeta `C:/src/tools`.
    * Sustituya los `.ico` del proyecto con los suyos propios.
    * Ejecute los siguientes comandos, seguidos y sin reiniciar MSYS:
        ```bash
        pacman -S mingw-w64-x86_64-advancecomp mingw-w64-x86_64-libpng mingw-w64-x86_64-optipng
        
        export PATH="/mingw64/bin:$PATH"
        export PATH="/c/src/tools:$PATH"

        cd /c/src/chromium/src
        python tools/resources/optimize-ico-files.py chrome/app/theme/chromium/win/chromium.ico 
        # Ejecutar este último comando con los diversos caminos de los .ico a comprobar.
        ```
        
        El _output_ del último comando debería ser parecido al siguiente:

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

5. Cambiar el archivo de BRANDING del navegador.
    
    * **Archivo a modificar: `chrome/app/theme/chromium/BRANDING`**
    * **Código a modificar:** 
        
        Sustituya las referencias al nombre de la compañía, el nombre del producto, etc., por los que desee que se muestren en les propiedades del archivo  y el listado de programas instalados en Windows. **Tenga en cuenta que no puede usar tildes.**

# Compilación de Chromium
Una vez terminadas las modificaciones del código fuente propuestas, ya puede compilar el proyecto, y obtendrá el navegador Nebula.

Para hacerlo, siga las instrucciones proporcionadas [en el documento referente a su sistema operativo](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md) desde el apartado `Setting up the build`.

### Argumentos de compilación recomendados
Para una compilación más rápida y un navegador perfectamente funcional al final de esta, le recomendamos que utilize los siguients argumentso de compilación (que también puede encontrar en `resources/` dentro de este mismo repositorio):

```shell
# Set build arguments here. See `gn help buildargs`.
is_debug=false
is_component_build=false
is_official_build=true
use_official_google_api_keys = false
symbol_level=0

#Configure su sistema operativo objetivo en el argumento siguiente. Las opciones disponibles son: "android", "chromeos", "ios", "linux", "nacl" (obsoleto), "win" 
target_os="win"

use_allocator_shim=true
enable_hangout_services_extension=false
blink_symbol_level=0
v8_symbol_level=0
```

Para poder utilizar estos argumentos correctamente, deberá editar también `[SU DISCO]/src/chromium/.gclient`, y en el apartado

```
"custom_vars": {
    },
```
añada

```
"custom_vars": {
      "checkout_pgo_profiles": True,
    },
```

Para guardar estos cambios, ejecute el siguiente comando:

```shell
gclient runhooks
```

### Cómo crear un instalador interactivo
Si quiere crear un instalador interactivo para usarlo en vez del `mini_installer` que proporciona el proyecto Chromium, puede hacerlo de la siguiente manera:

* Instálese el programa [Inno Setup Compiler](https://jrsoftware.org/isdl.php).
* Compile el `mini_installer` del Proyecto:
  
  ```shell
  cd out/Default
  autoninja mini_installer
  ```

* Descárguese o copie el script [`UI_installer.iss`](https://github.com/Isaac-Subirana/nebula/blob/main/resources/UI_installer.iss) que puede encontrar en la carpeta `resources` de este repositorio.
* Compílelo utilizando Inno Setup Compiler (tenga en cuenta que debe copiar el `mini_installer.exe` creado por el Proyecto en la carpeta donde se haya descargado el script).

Alternativamente, también puede crear usted su propio script y compilarlo directamente desde el programa que prefiera, y hacer que extraiga (o no) directamente los archivos del navegador en vez de ser una fachada sobre `mini_installer`.

# Test recomendados
### Del mismo proyecto Chromium
Recomendamos usar las utilidades `base_unittests` y `browser_tests`, que vienen en el código fuente del navegador. Puede compilarlas con el comando siguiente:

```shell
cd out/Default
autoninja base_unittests && autoninja browser_tests
```
Después, solo deberá ejecutarlos. Puede encontrar la documentación del Proyecto referente a todas las utilidades de testeo [aquí](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/testing_in_chromium.md).

### Referentes a la privacidad
* El analizador de privacidad de [Privacy.net](https://privacy.net/analyzer/).
* Los test de [browserleaks.com](https://browserleaks.com) referentes al [canvas](https://browserleaks.com/canvas) fingerprinting y al [WebGL](https://browserleaks.com/webgl) fingerprinting.
* Los test de [webglreport.com](https://webglreport.com/?v=1) y [webgpureport.org](https://webgpureport.org/), referentes también al fingerprinting.

### Referentes al rendimiento
Referentes al rendimiento, recomendamos usar los tres test oficiales ofrecidos por [browserbench.org](https://browserbench.org/):
* [Speedometer](https://browserbench.org/Speedometer3.1/), que se utiliza para medir la fluidez de aplicaciones web simples.
* [JetStream](https://browserbench.org/JetStream/), que se utiliza para medir el rendimiento del navegador ejecutando código JavaScript y WebAssembly (utilizados normalmente en aplicaciones web complejas).
* [MotionMark](https://browserbench.org/MotionMark1.3.1/), que se utiliza para medir la capacidad de un navegador para animar escenas complejas.

Nota: en estos test, las puntuaciones más altas son mejores.