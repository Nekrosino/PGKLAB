Shader "Custom/OutlineShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineWidth ("Outline Width", Range(0.001, 0.1)) = 0.01
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        fixed4 _OutlineColor;
        half _OutlineWidth;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Sprawdzamy jasno�� piksela i okre�lamy, czy znajduje si� na kraw�dzi obiektu
            half edge = 1.0 - tex2D(_MainTex, IN.uv_MainTex).r;

            // Sprawdzamy, czy piksel jest na kraw�dzi obiektu, i je�li tak, to renderujemy obram�wk�
            half alpha = saturate(edge - _OutlineWidth);

            // Renderujemy obram�wk� czarn�
            o.Albedo = _OutlineColor.rgb;
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
