/* Copyright (C) 2020 The Evolution X Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "CorrectHwRotation"
#include <stdlib.h>
#include <stdint.h>
#include <cutils/log.h>
#include <cutils/properties.h>
#include <gui/LayerState.h>
#include <hw_rotation/CorrectHwRotation.h>
// ----------------------------------------------------------------------------
namespace android {

// ----------------------------------------------------------------------------
CorrectHwRotation::CorrectHwRotation()
    : mHwRotation(0),
      mHwOrientation(DisplayState::eOrientationDefault)
{
    char value[PROPERTY_VALUE_MAX];

    // get info for panel physical rotation
    property_get("vendor.mtk_hwrotation", value, "0");
    mHwRotation = atoi(value);
    ALOGD("vendor.mtk_hwrotation (mHwRotation): %d\n", mHwRotation);

    // only primary display may need to correct hw rotation
    setupPrimaryHwOrientation();
}

CorrectHwRotation::~CorrectHwRotation() {
}

int CorrectHwRotation::getHwOrient() {
    return mHwOrientation;
}

void CorrectHwRotation::correctSize(uint32_t* w, uint32_t* h) {
    if (mHwOrientation & DisplayState::eOrientationSwapMask) {
        uint32_t tmp = *w;
        *w = *h;
        *h = tmp;
    }
}

void CorrectHwRotation::getCropFlags(uint32_t* flags) {
    if (mHwOrientation != DisplayState::eOrientationDefault) {
        switch (mHwOrientation) {
            case DisplayState::eOrientation90:
                *flags = Transform::ROT_90;
                break;
            case DisplayState::eOrientation180:
                *flags = Transform::ROT_180;
                break;
            case DisplayState::eOrientation270:
                *flags = Transform::ROT_270;
                break;
        }
    }
}

void CorrectHwRotation::correctRotation(uint32_t* rotation) {
    if (mHwOrientation != DisplayState::eOrientationDefault) {
        // convert hw orientation into flag presentation
        // here inverse transform needed
        uint8_t hw_rot_90  = 0x00;
        uint8_t hw_flip_hv = 0x00;
        switch (mHwOrientation) {
            case DisplayState::eOrientation90:
                hw_rot_90 = Transform::ROT_90;
                hw_flip_hv = Transform::ROT_180;
                break;
            case DisplayState::eOrientation180:
                hw_flip_hv = Transform::ROT_180;
                break;
            case DisplayState::eOrientation270:
                hw_rot_90  = Transform::ROT_90;
                break;
        }

        // transform flags operation
        // 1) flip H V if both have ROT_90 flag
        // 2) XOR these flags
        uint8_t rotation_rot_90  = *rotation & Transform::ROT_90;
        uint8_t rotation_flip_hv = *rotation & Transform::ROT_180;
        if (rotation_rot_90 & hw_rot_90) {
            rotation_flip_hv = (~rotation_flip_hv) & Transform::ROT_180;
        }
        *rotation = ((rotation_rot_90 ^ hw_rot_90) | (rotation_flip_hv ^ hw_flip_hv));
    }
}

status_t CorrectHwRotation::correctCaptureSize(uint32_t* reqWidth,
                                               uint32_t* reqHeight,
                                               uint32_t  hw_w,
                                               uint32_t  hw_h,
                                               const uint32_t rotation)
{
    correctSize(&hw_w, &hw_h);
    if (rotation & Transform::ROT_90)
        std::swap(hw_w, hw_h);

    if ((*reqWidth > hw_w) || (*reqHeight > hw_h)) {
        ALOGE("size mismatch (%d, %d) > (%d, %d)",
                *reqWidth, *reqHeight, hw_w, hw_h);
        return BAD_VALUE;
    }

    *reqWidth  = (!(*reqWidth))  ? hw_w : *reqWidth;
    *reqHeight = (!(*reqHeight)) ? hw_h : *reqHeight;
    return NO_ERROR;
}

void CorrectHwRotation::setupPrimaryHwOrientation() {
    switch (mHwRotation) {
        case 90:
            mHwOrientation = DisplayState::eOrientation90;
            break;
        case 180:
            mHwOrientation = DisplayState::eOrientation180;
            break;
        case 270:
            mHwOrientation = DisplayState::eOrientation270;
            break;
    }
}
// ----------------------------------------------------------------------------
CorrectHwRotationAPI *createHwRotationInstance() {
    return new CorrectHwRotation;
}

}
