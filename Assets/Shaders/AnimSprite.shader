Shader "Custom/AnimSprite"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Col ("Sprite Col", Float) = 1
		_Row("Sprite Row", Float) = 1
		_Speed("Speed", FLoat) = 1
	}
	SubShader
	{
		Pass{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Col;
			float _Row;
			float _Speed;

			struct appdata{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata i){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.pos);
				o.uv = i.uv;
				return o;
			}

			float4 frag(v2f i): SV_TARGET {
				//index
				float timeVal = fmod(_Time.y * _Speed, _Col * _Row);  
				float index = floor(timeVal);
				
				//row index
				float rowIndex = index / _Col;
				float colIndex = index % _Col;
				rowIndex = floor(rowIndex);
				colIndex = floor(colIndex);

				//scaler mapping
				float finalX = (i.uv.x + colIndex) / _Col;
				float finalY = (i.uv.y + rowIndex) / _Row;
				float2 calUV = float2(finalX, finalY);

				//set color
				float4 color = tex2D(_MainTex, calUV);
				return color;
			}

			ENDCG
		}
	}
}
