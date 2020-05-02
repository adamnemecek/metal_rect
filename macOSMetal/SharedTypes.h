//
//  SharedTypes.h
//  macOSMetal
//
//  Created by Adam Nemecek on 2/13/20.
//  Copyright © 2020 Zach Eriksen. All rights reserved.
//

#import <simd/simd.h>


struct Vertex {
    vector_float3 position;
    vector_float4 color;
};

struct Rect1 {
    float x,y,w,h;
    vector_float4 color;
};

struct Uniforms {
    vector_float2 size;
};
