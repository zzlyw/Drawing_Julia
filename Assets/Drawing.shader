// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Drawing" 
{  
    Properties  
    {  
        //定义基本属性，可以从编辑器里面进行设置的变量  
        _MainTex ("Texture", 2D) = "white" {} 
        cx("cx",range(-0.8,0.375))=-0.8 
        cy("cy",range(-1,1))=0.156
        scale("scale",range(1,3))=1.6
    }  
    SubShader  
    {  
        Tags { "RenderType"="Opaque" }  
        LOD 100  
        Pass  
        {  
            //在CGPROGRAM代码块中写自己的处理过程  
            CGPROGRAM  
            //定义顶点函数和片段函数的入口分别为vert和frag  
            #pragma vertex vert  
            #pragma fragment frag  
            //包含基本的文件，里面有一些宏定义和基本函数  
            #include "UnityCG.cginc"  
            //从应用程序传入顶点函数的数据结构定义  
            struct appdata  
            {  
                float4 vertex : POSITION;  
                float2 uv : TEXCOORD0;  
            };  
            //从顶点函数传入片段函数的数据结构定义  
            struct v2f  
            {  
                float2 uv : TEXCOORD0;  
                float4 vertex : SV_POSITION;  
            };  

            //定义贴图变量  
            sampler2D _MainTex;  
            float4 _MainTex_ST; 
            float cx ;
		    float cy ;
            float scale;               
            v2f vert (appdata v)  
            {  
                v2f o;  
                //将物体顶点从模型空间换到摄像机剪裁空间，也可采用简写方式——o.vertex = UnityObjectToClipPos(v.vertex);  
                o.vertex = UnityObjectToClipPos(v.vertex);  
                //2D UV坐标变换,也可以采用简写方式——o.uv = TRANSFORM_TEX(v.uv, _MainTex);  
                o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;  
                return o;  
            }             
            fixed4 frag (v2f i) : SV_Target  
            {  

            	
		        float ax = scale*(0.5-i.uv.x)/0.5;
		        float ay = scale*(0.5-i.uv.y)/0.5;
		        float juliaValue;
		        for(int index=0;index<200;index++)
		        {
		        	
		        	float _ax = ax*ax-ay*ay;
		            float _ay = ay*ax+ax*ay;
		            ax = _ax+cx;
		            ay = _ay+cy;
		            juliaValue = sqrt(ax*ax+ay*ay);
		            if(juliaValue > 100)
		            {
		            	return fixed4(0,0,0,1);
		            }

		        }
		            
                return fixed4(juliaValue,(fixed)(sin(_Time*100)+1)/2,(fixed)(cos(_Time*50)+1)/2,1);  
            }  
            ENDCG  
        }  
    }  
}  