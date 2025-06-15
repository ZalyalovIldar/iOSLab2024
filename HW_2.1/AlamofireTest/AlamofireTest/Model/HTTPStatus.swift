//
//  HTTPStatus.swift
//  AlamofireTest
//
//  Created by Данил Забинский on 19.03.2025.
//

import Foundation

enum HTTPStatus: String, CaseIterable {
    case `continue` = "Continue"
    case switchingProtocols = "Switching Protocols"
    case processing = "Processing"
    case earlyHints = "Early Hints"
    case ok = "OK"
    case created = "Created"
    case accepted = "Accepted"
    case nonAuthoritativeInformation = "Non-Authoritative Information"
    case noContent = "No Content"
    case resetContent = "Reset Content"
    case partialContent = "Partial Content"
    case multiStatus = "Multi-Status"
    case alreadyReported = "Already Reported"
    case transformationApplied = "Transformation Applied"
    case imUsed = "IM Used"
    case multipleChoices = "Multiple Choices"
    case movedPermanently = "Moved Permanently"
    case found = "Found"
    case seeOther = "See Other"
    case notModified = "Not Modified"
    case useProxy = "Use Proxy"
    case temporaryRedirect = "Temporary Redirect"
    case permanentRedirect = "Permanent Redirect"
    case badRequest = "Bad Request"
    case unauthorized = "Unauthorized"
    case paymentRequired = "Payment Required"
    case forbidden = "Forbidden"
    case notFound = "Not Found"
    case methodNotAllowed = "Method Not Allowed"
    case notAcceptable = "Not Acceptable"
    case proxyAuthenticationRequired = "Proxy Authentication Required"
    case requestTimeout = "Request Timeout"
    case conflict = "Conflict"
    case gone = "Gone"
    case lengthRequired = "Length Required"
    case preconditionFailed = "Precondition Failed"
    case payloadTooLarge = "Payload Too Large"
    case uriTooLong = "URI Too Long"
    case unsupportedMediaType = "Unsupported Media Type"
    case rangeNotSatisfiable = "Range Not Satisfiable"
    case expectationFailed = "Expectation Failed"
    case imATeapot = "I’m a teapot"
    case pageExpired = "Page Expired"
    case enhanceYourCalm = "Enhance Your Calm"
    case misdirectedRequest = "Misdirected Request"
    case unprocessableEntity = "Unprocessable Entity"
    case locked = "Locked"
    case failedDependency = "Failed Dependency"
    case tooEarly = "Too Early"
    case upgradeRequired = "Upgrade Required"
    case preconditionRequired = "Precondition Required"
    case tooManyRequests = "Too Many Requests"
    case requestHeaderFieldsTooLarge = "Request Header Fields Too Large"
    case noResponse = "No Response"
    case blockedByWindowsParentalControls = "Blocked by Windows Parental Controls"
    case unavailableForLegalReasons = "Unavailable For Legal Reasons"
    case sslCertificateError = "SSL Certificate Error"
    case sslCertificateRequired = "SSL Certificate Required"
    case httpRequestSentToHTTPSPort = "HTTP Request Sent to HTTPS Port"
    case tokenExpiredInvalid = "Token expired/invalid"
    case clientClosedRequest = "Client Closed Request"
    case internalServerError = "Internal Server Error"
    case notImplemented = "Not Implemented"
    case badGateway = "Bad Gateway"
    case serviceUnavailable = "Service Unavailable"
    case gatewayTimeout = "Gateway Timeout"
    case variantAlsoNegotiates = "Variant Also Negotiates"
    case insufficientStorage = "Insufficient Storage"
    case loopDetected = "Loop Detected"
    case bandwidthLimitExceeded = "Bandwidth Limit Exceeded"
    case notExtended = "Not Extended"
    case networkAuthenticationRequired = "Network Authentication Required"
    case webServerIsDown = "Web Server Is Down"
    case connectionTimedOut = "Connection Timed Out"
    case originIsUnreachable = "Origin Is Unreachable"
    case sslHandshakeFailed = "SSL Handshake Failed"
    case siteFrozen = "Site Frozen"
    case networkConnectTimeoutError = "Network Connect Timeout Error"
    
    var getCode: Int {
        switch self {
        case .continue:
            return 100
        case .switchingProtocols:
            return 101
        case .processing:
            return 102
        case .earlyHints:
            return 103
        case .ok:
            return 200
        case .created:
            return 201
        case .accepted:
            return 202
        case .nonAuthoritativeInformation:
            return 203
        case .noContent:
            return 204
        case .resetContent:
            return 205
        case .partialContent:
            return 206
        case .multiStatus:
            return 207
        case .alreadyReported:
            return 208
        case .transformationApplied:
            return 214
        case .imUsed:
            return 226
        case .multipleChoices:
            return 300
        case .movedPermanently:
            return 301
        case .found:
            return 302
        case .seeOther:
            return 303
        case .notModified:
            return 304
        case .useProxy:
            return 305
        case .temporaryRedirect:
            return 307
        case .permanentRedirect:
            return 308
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .paymentRequired:
            return 402
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .methodNotAllowed:
            return 405
        case .notAcceptable:
            return 406
        case .proxyAuthenticationRequired:
            return 407
        case .requestTimeout:
            return 408
        case .conflict:
            return 409
        case .gone:
            return 410
        case .lengthRequired:
            return 411
        case .preconditionFailed:
            return 412
        case .payloadTooLarge:
            return 413
        case .uriTooLong:
            return 414
        case .unsupportedMediaType:
            return 415
        case .rangeNotSatisfiable:
            return 416
        case .expectationFailed:
            return 417
        case .imATeapot:
            return 418
        case .pageExpired:
            return 419
        case .enhanceYourCalm:
            return 420
        case .misdirectedRequest:
            return 421
        case .unprocessableEntity:
            return 422
        case .locked:
            return 423
        case .failedDependency:
            return 424
        case .tooEarly:
            return 425
        case .upgradeRequired:
            return 426
        case .preconditionRequired:
            return 428
        case .tooManyRequests:
            return 429
        case .requestHeaderFieldsTooLarge:
            return 431
        case .noResponse:
            return 444
        case .blockedByWindowsParentalControls:
            return 450
        case .unavailableForLegalReasons:
            return 451
        case .sslCertificateError:
            return 495
        case .sslCertificateRequired:
            return 496
        case .httpRequestSentToHTTPSPort:
            return 497
        case .tokenExpiredInvalid:
            return 498
        case .clientClosedRequest:
            return 499
        case .internalServerError:
            return 500
        case .notImplemented:
            return 501
        case .badGateway:
            return 502
        case .serviceUnavailable:
            return 503
        case .gatewayTimeout:
            return 504
        case .variantAlsoNegotiates:
            return 506
        case .insufficientStorage:
            return 507
        case .loopDetected:
            return 508
        case .bandwidthLimitExceeded:
            return 509
        case .notExtended:
            return 510
        case .networkAuthenticationRequired:
            return 511
        case .webServerIsDown:
            return 521
        case .connectionTimedOut:
            return 522
        case .originIsUnreachable:
            return 523
        case .sslHandshakeFailed:
            return 525
        case .siteFrozen:
            return 530
        case .networkConnectTimeoutError:
            return 599
        }
    }
}
