<%@ page import="test.Subscription" %>

<div>
    <div class="data-card row p-1">
        <div class="col-2 align-content-center">

            <g:if test="${subscription.topic.createdBy.photo}">
                <g:link controller="userProfile" action="index" params="[username: subscription.topic.createdBy.username]">
                    <img src="${createLink(controller: 'dashboard', action: 'fetchImage', params: [user_id: subscription.topic.createdBy.id])}"
                         class="img-fluid w-80" alt="person-photo"/>
                </g:link>
            </g:if>
            <g:else>
                <g:link controller="userProfile" action="index" params="[username: subscription.topic.createdBy.username]">
                    <asset:image src="homepage/person-square.png" class="img-fluid" alt="person-photo"/>
                </g:link>
            </g:else>

        </div>
        <div class="col-10">
            <g:form controller="topic" action="editTopicName" params="[topic_id: subscription.topic.id]">
                <div class="row editSection" data-topic-id="${subscription.topic.id}"
                     style="display: inline-flex; display: none">
                    <div class="col-4 px-0">
                        <div class="input-group-sm">
                            <g:textField class="editTopic form-control" type="text"
                                         placeholder="${subscription.topic.name}" name="editTopic"/>
                        </div>
                    </div>

                    <div class="col-2"></div>

                    <div class="col-3">
                        <button type="submit" class="saveTopic btn btn-sm btn-primary btn-block w-100"
                                disabled>Save</button>
                    </div>

                    <div class="col-3">
                        <button type="button"
                                class="cancelButton btn btn-sm btn-secondary btn-block w-100">Cancel</button>
                    </div>
                </div>
            </g:form>
            <div class="viewSection row" style="display: block ;">
                <div class="row px-0">
                    <g:link controller="topicShow" action="index" target="_blank"
                            params="[topic_id: subscription.topic.id]">
                        <small>${subscription.topic.name}</small>
                    </g:link>
                </div>
            </div>

            <div class="row">
                <div class="col-5">
                    <small>
                        <g:link class="row text-muted" controller="userProfile" action="index"
                                params="[username: subscription.topic.createdBy.username]">
                            ${subscription.topic.createdBy.username}
                        </g:link>
                    </small>
                %{--  check if user is subscribed to topic -> "unsubscribe" option not visibible only to creator--}%
                    <% Subscription userSub = Subscription.findByUserAndTopicAndIsDeleted(session.user, subscription.topic, false) %>
                    <g:if test="${userSub}">
                        <g:if test="${userSub.user.username != subscription.topic.createdBy.username}">
                            <g:link class="row small" controller="dashboard" action="unsubscribe"
                                    params="[subscription_id: userSub.id]">
                                Unsubscribe
                            </g:link>
                        </g:if>
                    </g:if>
                    <g:else>
                        <g:if test="${session.user}">
                            <a href="#" class="row small" data-bs-toggle="modal" data-bs-target="#chooseSeriousnessModal">
                                subscribe
                            </a>
                            <tmpl:/dashboard/seriousness_modal subscription="${subscription}"/>
                        </g:if>
                    </g:else>
                </div>

                <div class="col-5">
                    <small class="row text-muted">Subscriptions</small>
                    <g:link controller="userProfile" action="index"
                            params="[username: subscription.topic.createdBy.username]">
                        <small class="row">${test.Subscription.findAllByTopicAndIsDeleted(subscription.topic, false).size()}</small>
                    </g:link>
                </div>


                <div class="col-2">
                    <small class="row text-muted">Posts</small>
                    <g:link controller="userProfile" action="index"
                            params="[username: subscription.topic.createdBy.username]">
                        <small class="row">${subscription.topic.resources.size()}</small>
                    </g:link>
                </div>

            </div>
        </div>

    %{--    check if user is subscribed to topic--}%
        <g:if test="${userSub}">
            <div class="row d-flex justify-content-end justify-content-end gap-3">
                <div class="col-3 form-group">
                    <g:form controller="topic" action="changeSeriousness" params="[subscription_id: subscription.id]">
                        <g:select name="seriousness" class="form-select form-select-sm"
                                  from="${['Serious', 'Very_Serious', 'Casual']}"
                                  value="${subscription.seriousness}"
                                  onchange="this.form.submit()"/>
                    </g:form>
                </div>
            %{--            check if user is the creator if topic-> can change visibility--}%
                <g:if test="${session.user.username == subscription.topic.createdBy.username}">
                    <div class="col-3 form-group">
                        <g:form controller="topic" action="changeVisibility"
                                params="[topic_id: subscription.topic.id]">
                            <g:select name="visibility" class="form-select form-select-sm"
                                      from="${['Private', 'Public']}"
                                      value="${subscription.topic.visibility}"
                                      onchange="this.form.submit()"/>
                        </g:form>
                    </div>
                </g:if>
                <div class="col-3 icons gap-2 d-flex align-items-center">
                    <a href="#" class="icon-link" data-bs-toggle="modal" data-bs-target="#sendInviteModal" title="Send Invite">
                        <i class="bi bi-envelope fs-4 mr-4 text-dark"></i>
                    </a>
                    <!--Send Invitation Modal -->
                    <div class="modal fade" id="sendInviteModal" tabindex="-1" aria-labelledby="sendInviteModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <g:form controller="mail" action="sendInvite">
                                    <div class="modal-header pb-1 d-flex align-content-center">
                                        <h5 class="modal-title" id="sendInviteModalLabel">Send invitation</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>

                                    <div class="modal-body">
                                        <div class="container">
                                            <div class="row mb-4">
                                                <label class="col-4 col-form-label" for="email">Email:</label>

                                                <div class="col-8">
                                                    <g:textField class="form-control small" placeholder="Email" name="email" type="email"
                                                                 required=""/>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <label class="col-4 col-form-label" for="topic">Topic:</label>

                                                <div class="col-8">
                                                    <g:select class="form-select form-select-sm" name="topic"
                                                              from="${subscriptions}"
                                                              optionKey="topic"
                                                              optionValue="${{ it.topic.name + ' -> ['+ it.topic.createdBy.username +']' }}"
                                                              required="">
                                                    </g:select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <div class="row">
                                            <div class="col">
                                                <g:submitButton class="btn btn-primary" name="sendInvite" value="Invite"/>
                                            </div>

                                            <div class="col">
                                                <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Cancel</button>
                                            </div>
                                        </div>
                                    </div>
                                </g:form>
                            </div>
                        </div>
                    </div>



                %{-- check if user is the creator if topic-> can edit/delete topic--}%
                    <g:if test="${session.user.username == subscription.topic.createdBy.username}">
                        <a href="javascript:void(0)" class="editIcon icon-link"
                           data-topic-id="${subscription.topic.id}">
                            <i class="bi bi-pencil-square fs-4 mr-4 text-dark"></i></a>
                        <g:link class="icon-link" action="deleteTopic" controller="topic"
                                params="[topic_id: subscription.topic.id]">
                            <i class="bi bi-trash fs-4 mr-4 text-dark"></i>
                        </g:link>
                    </g:if>
                </div>
            </div>
        </g:if>

    </div>

</div>


