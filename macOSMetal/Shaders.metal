//
//  Shaders.metal
//  macOSMetal
//
//  Created by Zach Eriksen on 4/30/18.
//  Copyright © 2018 Zach Eriksen. All rights reserved.
//

#include <metal_stdlib>
#include "SharedTypes.h"

using namespace metal;


struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};

vertex VertexOut basic_vertex_function(const device Vertex *vertices [[ buffer(0) ]],
                                       uint vertexID [[ vertex_id  ]]) {
    VertexOut vOut;
    vOut.position = float4(vertices[vertexID].position,1);
    vOut.color = vertices[vertexID].color;
    return vOut;
}

fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]]) {
    return vIn.color;
}
