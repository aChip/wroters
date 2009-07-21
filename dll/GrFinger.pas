{******************************************************
 *                                                    *
 * Fingerprint SDK                                    *
 *                                                    *
 * GrFinger.pas                                       *
 * pascal file for GrFinger Library                   *
 *                                                    *
 * Copyright (c) 2004-2007 Griaule Biometrics LTDA.   *
 *                                                    *
 * Last Modified: 2006-05-23 Revision: 3              *
 *                                                    *
 ******************************************************}

unit GrFinger;

interface

uses
  Windows;

const

//*****************************************************
//RETURN CODES
//*****************************************************
//success
GR_OK =                                              0;
GR_BAD_QUALITY =                                     0;
GR_MEDIUM_QUALITY =                                  1;
GR_HIGH_QUALITY =                                    2;
GR_MATCH =                                           1;
GR_NOT_MATCH =                                       0;
GR_DEFAULT_USED =                                    3;
GR_ENROLL_NOT_READY =                                0;
GR_ENROLL_SUFFICIENT =                               1;
GR_ENROLL_GOOD =                                     2;
GR_ENROLL_VERY_GOOD =                                3;
GR_ENROLL_MAX_LIMIT_REACHED =                        4;
//initialization errors codes
GR_ERROR_INITIALIZE_FAIL =                          -1;
GR_ERROR_NOT_INITIALIZED =                          -2;
GR_ERROR_FAIL_LICENSE_READ =                        -3;
GR_ERROR_NO_VALID_LICENSE =                         -4;
GR_ERROR_NULL_ARGUMENT =                            -5;
GR_ERROR_FAIL =                                     -6;
GR_ERROR_ALLOC =                                    -7;
GR_ERROR_PARAMETERS =                               -8;
//extract and match errors codes
GR_ERROR_WRONG_USE =                              -107;
GR_ERROR_EXTRACT =                                -108;
GR_ERROR_SIZE_OFF_RANGE =                         -109;
GR_ERROR_RES_OFF_RANGE =                          -110;
GR_ERROR_CONTEXT_NOT_CREATED =                    -111;
GR_ERROR_INVALID_CONTEXT =                        -112;
GR_ERROR_ERROR =                                  -113;
GR_ERROR_NOT_ENOUGH_SPACE =                       -114;
GR_ERROR_BAD_QUALITY =                            -115;
//capture error codes
GR_ERROR_CONNECT_SENSOR =                         -201;
GR_ERROR_CAPTURING =                              -202;
GR_ERROR_CANCEL_CAPTURING =                       -203;
GR_ERROR_INVALID_ID_SENSOR =                      -204;
GR_ERROR_SENSOR_NOT_CAPTURING =                   -205;
GR_ERROR_INVALID_EXT =                            -206;
GR_ERROR_INVALID_FILENAME =                       -207;
GR_ERROR_INVALID_FILETYPE =                       -208;
GR_ERROR_SENSOR =                                 -209;
//license error codes
GR_ERROR_GET_HARDWARE_KEY =                       -301;
GR_ERROR_INTERNET_CONNECTION =                    -302; 
GR_ERROR_BAD_REQUEST =                            -303;
GR_ERROR_INVALID_PRODUCT_KEY =                    -304;
GR_ERROR_INSUFFICIENT_CREDIT =                    -305;
GR_ERROR_NO_HARDWARE_BOUND =                      -306;
GR_ERROR_HTTP_AUTHORIZATION =                     -307;
GR_ERROR_WRONG_PRODUCT_KEY =                      -308;
GR_ERROR_INTERNAL_SERVER =                        -309;
GR_ERROR_WRITING_LICENSE_FILE =                   -310;
GR_ERROR_PK_NOT_LINKED =                          -311;
GR_ERROR_PK_NOT_APPROVED =                        -312;

//*****************************************************
//CONSTS
//*****************************************************
//file format codes
GRCAP_IMAGE_FORMAT_BMP =                           501;

//event values codes
GR_PLUG =                                           21;
GR_UNPLUG =                                         20;
GR_FINGER_DOWN =                                    11;
GR_FINGER_UP =                                      10;
GR_IMAGE =                                          30;
//image consts
GR_DEFAULT_RES =                                   500;
GR_DEFAULT_DIM =                                   500;
GR_MAX_SIZE_TEMPLATE =                           10000;
GR_MAX_IMAGE_WIDTH =                              1280;
GR_MAX_IMAGE_HEIGHT =                             1280;
GR_MAX_RESOLUTION =                               1000; // DPI
GR_MIN_IMAGE_WIDTH =                                50;
GR_MIN_IMAGE_HEIGHT =                               50;
GR_MIN_RESOLUTION =                                125; // DPI
//match const
GR_MAX_THRESHOLD =                                 200;
GR_MIN_THRESHOLD =                                  10;
GR_VERYLOW_FRR =                                    30; // 1 IN 1000
GR_LOW_FRR =                                        45; // 1 IN 10000
GR_LOW_FAR =                                        60; // 1 IN 30000
GR_VERYLOW_FAR =                                    80; // 1 IN 300000
GR_ROT_MIN =                                         0;
GR_ROT_MAX =                                       180;
//context const
GR_DEFAULT_CONTEXT =                                 0;
GR_NO_CONTEXT =                                     -1;
//colors for BiometricDisplay
GR_IMAGE_NO_COLOR =                          $1fffffff;
//Version Constants
GRFINGER_FULL =                                      1;
GRFINGER_LIGHT =                                     2;
//Template format constants
GR_FORMAT_DEFAULT =                                  0;
GR_FORMAT_GR001 =                                    1;
GR_FORMAT_GR002 =                                    2;
GR_FORMAT_GR003 =                                    3;
GR_FORMAT_CLASSIC =                                100;
GR_FORMAT_ISO =                                    200;
GR_FORMAT_ANSI =                                   201;


//*****************************************************
//TYPE DEFINITIONS
//*****************************************************
type
// Event types
GRCAP_STATUS_EVENTS = Integer;
GRCAP_FINGER_EVENTS = Integer;
// Image format
GRCAP_IMAGE_FORMAT = Integer;
LPHBitmap = ^HBITMAP;
LPHDC     = ^LongInt;

//*****************************************************
//CALLBACK TYPES
//*****************************************************
GRCAP_STATUS_EVENT_PROC = Procedure(idSensor: Pchar; event: GRCAP_STATUS_EVENTS); stdcall;
GRCAP_FINGER_EVENT_PROC = Procedure(idSensor: Pchar; event: GRCAP_FINGER_EVENTS); stdcall;
GRCAP_IMAGE_EVENT_PROC = Procedure(idSensor: PChar; width: Integer; height: Integer; rawImage: PChar; res: Integer); stdcall;

//*****************************************************
// Functions - CAPTURE
//*****************************************************
function GrCapInitialize(StatusEventHandler: GRCAP_STATUS_EVENT_PROC): Integer; stdcall;

function GrCapFinalize(): Integer; stdcall;

function GrCapStartCapture(idSensor: PChar; FingerEventHandler: GRCAP_FINGER_EVENT_PROC; ImageEventHandler: GRCAP_IMAGE_EVENT_PROC): Integer; stdcall;

function GrCapStopCapture(idSensor: PChar): Integer; stdcall;

function GrCapRawImageToHandle(rawImage: PChar; width, height: Integer; hdc: HDC; var handle: HBITMAP): Integer; stdcall;

function GrCapSaveRawImageToFile(rawImage: PChar; width, height: Integer; filename: String; imageFormat: GRCAP_IMAGE_FORMAT): Integer; stdcall;

function GrCapLoadImageFromFile(filename: String; res: Integer): Integer; stdcall;

function GrBiometricDisplay(templateQuery,rawImage: PChar; width, height,res: Integer; hdc: HDC; var handle: HBITMAP; context: Integer): Integer; stdcall;

function GrBiometricDisplayRaw(templateQuery,rawImage: PChar; width, height,res: Integer; outputImageRGB: PChar; context: Integer): Integer; stdcall;

//*****************************************************
// Functions - EXTRACT
//*****************************************************
function GrExtract(rawimage: Pchar; width: Integer; height: Integer; res: Integer; tpt: PChar; var tptSize: Integer; context: Integer): Integer; stdcall;

function GrExtractEx(rawimage: Pchar; width: Integer; height: Integer; res: Integer; tpt: PChar; var tptSize: Integer; context: Integer; tptFormat: Integer): Integer; stdcall;

//*****************************************************
// Functions - TEMPLATE CONVERSION
//*****************************************************

function GrConvertTemplate(oldTpt: Pchar; newTpt: Pchar; newTptSize: Integer; context: Integer; format: Integer): Integer; stdcall;

//*****************************************************
// Functions - CONSOLIDATION
//*****************************************************
function GrStartEnroll(context: Integer): Integer; stdcall;

function GrEnroll(rawimage: Pchar; width: Integer; height: Integer; res: Integer; tpt: PChar; var tptSize: Integer; var quality: Integer; tptFormat: Integer; context: Integer): Integer; stdcall;

//*****************************************************
// Functions - BASE64
//*****************************************************
function GrEncodeBase64(buffer: Pchar; bufferSize:Integer; encodedBuffer: Pchar; var encodedSize: Integer): Integer; stdcall;

function GrDecodeBase64(encodedBuffer: Pchar; encodedSize:Integer; decodedBuffer: Pchar; var decodedSize: Integer): Integer; stdcall;

function GrIsBase64Encoding(buffer: Pchar; bufferSize:Integer): Boolean; stdcall;

//*****************************************************
// Functions - MATCH
//*****************************************************
function GrInitialize: Integer; stdcall;

function GrFinalize: Integer; stdcall;

function GrCreateContext( var contextId: Integer): Integer; stdcall;

function GrDestroyContext(contextId: Integer): Integer; stdcall;

function GrVerify(queryTemplate: PChar; referenceTemplate: PChar; var verifyScore: Integer; context: Integer): Integer; stdcall;

function GrIdentifyPrepare(templateQuery: PChar; context: Integer): Integer; stdcall;

function GrIdentify(templateReference: PChar; var identifyScore: Integer; context: Integer): Integer; stdcall;

//*****************************************************
// Functions - CONFIG
//*****************************************************
function GrSetLicenseFolder(licenseFolder: String): Integer; stdcall;

function GrSetIdentifyParameters(identifyThreshold: Integer; identifyRotationTolerance: Integer; context: Integer): Integer; stdcall;

function GrSetVerifyParameters(verifyThreshold: Integer; verifyRotationTolerance: Integer; context: Integer): Integer; stdcall;

function GrGetIdentifyParameters(var identifyThreshold: Integer; var identifyRotationTolerance: Integer; context: Integer): Integer; stdcall;

function GrGetVerifyParameters(var verifyThreshold: Integer; var verifyRotationTolerance: Integer; context: Integer): Integer; stdcall;

function GrSetBiometricDisplayColors(minutiaeColor, minutiaeMatchedColor: Integer; segmentColor, segmentMatchedColor: Integer; directionColor, directionMatchedColor: Integer): Integer; stdcall;

function GrGetGrFingerVersion(var majorVersion: Byte; var minorVersion: Byte): Integer; stdcall;

function GrInstallLicense(productKey: String): Integer; stdcall;

implementation
//*****************************************************
// EXTERNAL DECLARATIONS
//*****************************************************
function GrCapInitialize;               stdcall; external 'Finger.dll'
                                        name '_GrCapInitialize@4';

function GrCapFinalize;                 stdcall; external 'Finger.dll'
                                        name '_GrCapFinalize@0';

function GrCapStartCapture;             stdcall; external 'Finger.dll'
                                        name '_GrCapStartCapture@12';

function GrCapStopCapture;              stdcall; external 'Finger.dll'
                                        name '_GrCapStopCapture@4';

function GrCapRawImageToHandle;         stdcall; external 'Finger.dll'
                                        name '_GrCapRawImageToHandle@20';

function GrCapSaveRawImageToFile;       stdcall; external 'Finger.dll'
                                        name '_GrCapSaveRawImageToFile@20';

function GrCapLoadImageFromFile;        stdcall; external 'Finger.dll'
                                        name '_GrCapLoadImageFromFile@8';

function GrExtract;                     stdcall; external 'Finger.dll'
                                        name '_GrExtract@28';

function GrExtractEx;                   stdcall; external 'Finger.dll'
                                        name '_GrExtractEx@32';
                                        
function GrConvertTemplate;             stdcall; external 'Finger.dll'
                                        name '_GrConvertTemplate@20';

function GrStartEnroll;                 stdcall; external 'Finger.dll'
                                        name '_GrStartEnroll@4';

function GrEnroll;                      stdcall; external 'Finger.dll'
                                        name '_GrEnroll@36';                                        

function GrInitialize;                  stdcall; external 'Finger.dll'
                                        name '_GrInitialize@0';

function GrFinalize;                    stdcall; external 'Finger.dll'
                                        name '_GrFinalize@0';

function GrCreateContext;               stdcall; external 'Finger.dll'
                                        name '_GrCreateContext@4';

function GrDestroyContext;              stdcall; external 'Finger.dll'
                                        name '_GrDestroyContext@4';

function GrVerify;                      stdcall; external 'Finger.dll'
                                        name '_GrVerify@16';

function GrIdentifyPrepare;             stdcall; external 'Finger.dll'
                                        name '_GrIdentifyPrepare@8';

function GrIdentify;                    stdcall; external 'Finger.dll'
                                        name '_GrIdentify@12';

function GrSetLicenseFolder;            stdcall; external 'Finger.dll'
                                        name '_GrSetLicenseFolder@4';

function GrSetIdentifyParameters;       stdcall; external 'Finger.dll'
                                        name '_GrSetIdentifyParameters@12';

function GrSetVerifyParameters;         stdcall; external 'Finger.dll'
                                        name '_GrSetVerifyParameters@12';

function GrGetIdentifyParameters;       stdcall; external 'Finger.dll'
                                        name '_GrGetIdentifyParameters@12';

function GrGetVerifyParameters;         stdcall; external 'Finger.dll'
                                        name '_GrGetVerifyParameters@12';

function GrBiometricDisplay;            stdcall; external 'Finger.dll'
                                        name '_GrBiometricDisplay@32';
                                        
function GrBiometricDisplayRaw;         stdcall; external 'Finger.dll'
                                        name '_GrBiometricDisplayRaw@28';

function GrSetBiometricDisplayColors;   stdcall; external 'Finger.dll'
                                        name '_GrSetBiometricDisplayColors@24';

function GrGetGrFingerVersion;          stdcall; external 'Finger.dll'
                                        name '_GrGetGrFingerVersion@8';
										
function GrInstallLicense;              stdcall; external 'Finger.dll'
                                        name '_GrInstallLicense@4';
										
function GrEncodeBase64;                stdcall; external 'Finger.dll'
                                        name '_GrEncodeBase64@16';                                        

function GrDecodeBase64;                stdcall; external 'Finger.dll'
                                        name '_GrDecodeBase64@16';                                        
										
function GrIsBase64Encoding;            stdcall; external 'Finger.dll'
                                        name '_GrIsBase64Encoding@8';                                        
										
end.
