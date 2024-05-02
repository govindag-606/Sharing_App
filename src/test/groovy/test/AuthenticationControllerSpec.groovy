package test

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class AuthenticationControllerSpec extends Specification implements ControllerUnitTest<AuthenticationController> {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
        expect:"fix me"
            true == false
    }

    static class UserProfileControllerSpec extends Specification implements ControllerUnitTest<UserProfileController> {

        def setup() {
        }

        def cleanup() {
        }

        void "test something"() {
            expect:"fix me"
                true == false
        }
    }
}
