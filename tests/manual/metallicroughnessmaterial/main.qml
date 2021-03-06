/*
    main.qml

    This file is part of Kuesa.

    Copyright (C) 2018-2019 Klarälvdalens Datakonsult AB, a KDAB Group company, info@kdab.com
    Author: Kevin Ottens <kevin.ottens@kdab.com>

    Licensees holding valid proprietary KDAB Kuesa licenses may use this file in
    accordance with the Kuesa Enterprise License Agreement provided with the Software in the
    LICENSE.KUESA.ENTERPRISE file.

    Contact info@kdab.com if any conditions of this licensing are not clear to you.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import Qt3D.Core 2.10
import Qt3D.Render 2.10
import Qt3D.Input 2.0
import Qt3D.Animation 2.10
import Qt3D.Extras 2.10
import Kuesa 1.1 as Kuesa

Entity {
    id: scene

    components: [
        RenderSettings {
            Kuesa.ForwardRenderer {
                camera: mainCamera
            }
        },
        InputSettings { },
        PointLight {
            color: "black"
            intensity: 0
        },
        EnvironmentLight {
            id: envLight
            property string envMapFormat: (Qt.platform.os == "osx" || Qt.platform.os == "ios" || Qt.platform.os == "android") ? "_16f" : ""

            irradiance: TextureLoader {
                source: "qrc:/wobbly_bridge" + envLight.envMapFormat + "_irradiance.dds"
                wrapMode {
                    x: WrapMode.ClampToEdge
                    y: WrapMode.ClampToEdge
                }
                generateMipMaps: false
            }
            specular: TextureLoader {
                source: "qrc:/wobbly_bridge" + envLight.envMapFormat + "_specular.dds"
                wrapMode {
                    x: WrapMode.ClampToEdge
                    y: WrapMode.ClampToEdge
                }
                generateMipMaps: false
            }
        }
    ]


    TextureLoader {
        id: metalRoughTexture
        source: "qrc:/assets/models/powerup/metalroughness.png"
    }

    TextureLoader {
        id: normalTexture
        source: "qrc:/assets/models/powerup/normal.png"
    }

    TextureLoader {
        id: ambientOcclusionTexture
        source: "qrc:/assets/models/powerup/ambientocclusion.png"
    }

    TextureLoader {
        id: emissiveTexture
        source: "qrc:/assets/models/powerup/emissive.png"
    }

    Entity {
        components: [
            Mesh {
                source: "qrc:/assets/models/powerup/powerup.obj"
            },
            Kuesa.MetallicRoughnessMaterial {
                baseColorFactor: _controller.baseColorFactor
                baseColorMap: _controller.useBaseColorMap ? baseColorTexture : null
                metallicFactor: _controller.metallicFactor
                roughnessFactor: _controller.roughnessFactor
                metalRoughMap: _controller.useMetalRoughMap ? metalRoughTexture : null
                normalScale: _controller.normalScale
                normalMap: _controller.useNormalMap ? normalTexture : null
                ambientOcclusionMap: _controller.useAmbientOcclusionMap ? ambientOcclusionTexture : null
                emissiveFactor: _controller.emissiveFactor
                emissiveMap: _controller.useEmissiveMap ? emissiveTexture : null
                textureTransform: _controller.textureTransform
                usingColorAttribute: _controller.useColorAttribute
                doubleSided: _controller.doubleSided
                toneMappingAlgorithm: _controller.toneMappingAlgorithm
            }
        ]
    }

    Camera {
        id: mainCamera
        position: Qt.vector3d(1, 2, 4)
        viewCenter: Qt.vector3d(0, 0, 0)
        fieldOfView: 60
    }

    FirstPersonCameraController {
        camera: mainCamera
        linearSpeed: 5
        lookSpeed: 180
    }

    Entity {
        Kuesa.Skybox {
            baseName: "qrc:/wobbly_bridge" + envLight.envMapFormat + "_irradiance"
            extension: ".dds"
        }
    }
}
