# IRule to get the nonce value of a CSP header and put it in the HTML script tags
# This is needed for the JavaScript that is injected by an ASM Bot Defence profile
# Make sure to put a HTML profile on the virtual server that triggers an
# event when it detects a script-tag in the HTML.

when HTTP_RESPONSE {
    # Check if the response header contains a CSP
    if {[HTTP::header exists "Content-Security-Policy"]} {
        # Get the CSP header value
        set csp [HTTP::header value "Content-Security-Policy"]
        # Check if the CSP contains a nonce
        if {[string first "nonce-" $csp] != -1} {
            # Get the nonce value
            set idx [string first "nonce-" $csp]
            set nonce [string trim [string range $csp $idx end-3] "nonce-"]
        }
    }
}

# Event if the HTML profile rule is triggered
when HTML_TAG_MATCHED {
    # Check if nonce value allready exists, if not add it
    if {not [HTML::tag attribute exists "nonce"]} {
        HTML::tag attribute insert "nonce" $nonce
    }
}