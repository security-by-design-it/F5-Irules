when HTTP_REQUEST {
    if { ( [HTTP::cookie exists "test_cookie"] ) } {
        set cookie_exists 1
    } else {
        set cookie_exists 0
    }
}

when HTTP_RESPONSE {
    if { not ( $cookie_exists ) } {
        set uniqueID [TMM::cmp_unit][clock clicks]
        HTTP::cookie insert name "test_cookie" value $uniqueID path "/"
    }
}