package test

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class CreateTopicControllerSpec extends Specification implements ControllerUnitTest<CreateTopicControllerSpec> {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
        expect:"fix me"
            true == false
    }

    static class TopicShowControllerSpec extends Specification implements ControllerUnitTest<TopicShowController> {

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
