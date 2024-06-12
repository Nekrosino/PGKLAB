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
            // Sprawdzamy jasnoœæ piksela i okreœlamy, czy znajduje siê na krawêdzi obiektu
            half edge = 1.0 - tex2D(_MainTex, IN.uv_MainTex).r;

            // Sprawdzamy, czy piksel jest na krawêdzi obiektu, i jeœli tak, to renderujemy obramówkê
            half alpha = saturate(edge - _OutlineWidth);

            // Renderujemy obramówkê czarn¹
            o.Albedo = _OutlineColor.rgb;
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
