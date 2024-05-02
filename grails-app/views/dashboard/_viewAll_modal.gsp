<div class="modal fade" id="viewAllModal" tabindex="-1" aria-labelledby="viewAllModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header pb-1 d-flex align-content-center">
                <h5 class="modal-title" id="viewAllModalLabel">Topics</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <div class="container">
                    <g:each in="${viewAll}" var="subscription">
                        <div class="row p-3">
                            <div class="col d-flex align-items-center">
                                <span class="topic-name">${subscription.topic.name}</span>
                            </div>
                            <div class="col d-flex justify-content-between align-items-center">
%{--                                <g:link controller="topicShow" action="index" params="${[topic_id: subscription.topic.id]}">View</g:link>--}%
                                <g:link class="btn btn-sm btn-outline-primary w-40"  controller="topicShow" action="index" params="${[topic_id: subscription.topic.id]}">View</g:link>
                            </div>
                            <div class="col d-flex justify-content-end align-items-center">
                                <g:if test="${subscription.user.id != session.user.id}">
                                    <button class="btn btn-success" style="width: 150px;" data-bs-toggle="modal"
                                            data-bs-target="#chooseSeriousnessModal2">
                                        subscribe
                                    </button>
                                    <!-- Seriousness Modal -->
                                    <div class="modal fade" id="chooseSeriousnessModal2" tabindex="-1"
                                         aria-labelledby="chooseSeriousnessModal2Label" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">

                                                <g:form controller="subscription" action="subscribe">
                                                    <div class="modal-header pb-1 d-flex align-content-center">
                                                        <h5 class="modal-title"
                                                            id="chooseSeriousnessModal2Label">Choose Seriousness Level</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                                aria-label="Close"></button>
                                                    </div>

                                                    <input type="hidden" name="topic_id"
                                                           value="${subscription.topic.id}"/>

                                                    <div class="modal-body">
                                                        <div class="container">
                                                            <div class="row">
                                                                <div class="form-group">
                                                                    <g:select class="form-select" name="seriousness"
                                                                              required=""
                                                                              from="['Serious', 'Very_Serious', 'Casual']"/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="modal-footer">
                                                        <div class="row">
                                                            <div class="col">
                                                                <g:submitButton class="btn btn-primary" name="subscribe"
                                                                                value="Save changes"/>
                                                            </div>

                                                            <div class="col">
                                                                <button type="button" class="btn btn-secondary"
                                                                        data-bs-dismiss="modal">Close</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </g:form>

                                            </div>
                                        </div>
                                    </div>
                                </g:if>
                                <g:elseif test="${subscription.topic.createdBy.id != session.user.id}">
                                    <g:link controller="dashboard" action="unsubscribe" params="[subscription_id: subscription.id]"
                                            class="btn btn-danger" style="width: 150px;">Unsubscribe
                                    </g:link>
                                </g:elseif>
                                <g:else>
                                    <button class="btn btn-sm btn-info disabled" style="width: 120px;" title="Topic Creator">
                                        Unsubscribe
                                    </button>
                                </g:else>
                            </div>
                        </div>
                    </g:each>
                </div>
            </div>
        </div>
    </div>
</div>
