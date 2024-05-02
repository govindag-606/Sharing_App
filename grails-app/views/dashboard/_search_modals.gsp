<%@ page import="test.Subscription" %>

<%
    def subscriptions2
    if(session.user?.admin){
        subscriptions = Subscription.findAllByIsDeleted(false)
    }else {
       subscriptions = Subscription.findAllByUserAndIsDeleted(session.user, false)
    }
%>
<g:set var="subs" value="${subscriptions ?: subscriptions2}"/>

<!--Create Topic Modal -->
<div class="modal fade" id="createTopicModal" tabindex="-1" aria-labelledby="createTopicModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <g:form controller="topic" action="createTopic">
                <div class="modal-header pb-1 d-flex align-content-center">
                    <h5 class="modal-title" id="createTopicModalLabel">Create Topic</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="container">
                        <div class="row mb-4">
                            <label class="col-4 col-form-label" for="name">Name:</label>

                            <div class="col-8">
                                <g:textField class="form-control small" placeholder="Name" name="name" required=""/>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-4 col-form-label" for="visibility">Visibility:</label>

                            <div class="col-8">
                                <g:select class="form-select form-select-sm" name="visibility"
                                          id="visibility" from="${['Public', 'Private']}" required=""/>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <div class="row">
                        <div class="col">
                            <g:submitButton class="btn btn-primary" name="createTopic" value="Save"/>
                        </div>

                        <div class="col">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>


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
                            <label class="col-4 col-form-label" for="name">Email:</label>

                            <div class="col-8">
                                <g:textField class="form-control small" placeholder="Email" name="email" type="email"
                                             required=""/>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-4 col-form-label" for="topic">Topic:</label>

                            <div class="col-8">
                                <g:select class="form-select form-select-sm" name="topic" from="${subs}"
                                          optionKey="topic" optionValue="${{ it.topic.name + ' -> [' + it.topic.createdBy.username + ']' }}"
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


<!--Share Link Modal -->
<div class="modal fade" id="shareLinkModal" tabindex="-1" aria-labelledby="shareLinkModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <g:form controller="dashboard" action="shareLink" onsubmit="return validateUrlInput()">
                <div class="modal-header pb-1 d-flex align-content-center">
                    <h5 class="modal-title" id="shareLinkModalLabel">Share Link</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="container">
                        <div class="row mb-4">
                            <label class="col-4 col-form-label" for="name">Link:</label>

                            <div class="col-8">
                                <g:textField class="form-control small" placeholder="Link" name="url" type="url"
                                             required=""/>
                                <div id="urlInputError" class="invalid-feedback"></div>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <label class="col-4 col-form-label" for="description">Description:</label>

                            <div class="col-8">
                                <g:textArea class="form-control" name="description" placeholder="Description"
                                            type="text" required=""/>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-4 col-form-label" for="topic_string">Topic:</label>

                            <div class="col-8">
                                <g:select class="form-select form-select-sm" name="topic_string" from="${subs}"
                                          optionKey="topic"
                                          optionValue="${{ it.topic.name + ' -> [' + it.topic.createdBy.username + ']' }}"
                                          required="">
                                </g:select>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <div class="row">
                        <div class="col">
                            <g:submitButton class="btn btn-primary" name="createLink" value="Share"/>
                        </div>

                        <div class="col">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>


<!--Share Document Modal -->
<div class="modal fade" id="shareDocumentModal" tabindex="-1" aria-labelledby="shareDocumentModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <g:form controller="dashboard" action="shareDocument" enctype="multipart/form-data">
                <div class="modal-header pb-1 d-flex align-content-center">
                    <h5 class="modal-title" id="shareDocumentModalLabel">Share Document</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="container">
                        <div class="row mb-4">
                            <label class="col-4 col-form-label">Document:</label>

                            <div class="col-8">
                                <div class="input-group">
                                    <input type="text" class="form-control" id="file-selected"
                                           placeholder="Choose file">
                                    <label class="input-group-text" for="filePath">Browse</label>
                                    <input type="file" id="filePath" class="form-control d-none" name="filePath"
                                           required=""
                                           onchange="document.getElementById('file-selected').value = this.files[0].name">
                                </div>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <label class="col-4 col-form-label" for="description">Description:</label>

                            <div class="col-8">
                                <g:textArea class="form-control" name="description" placeholder="Description"
                                            type="text" required=""/>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-4 col-form-label" for="topic1">Topic:</label>

                            <div class="col-8">
                                <g:select class="form-select form-select-sm" name="topic1"
                                          from="${subs}"
                                          optionKey="topic"
                                          optionValue="${{ it.topic.name + ' -> [' + it.topic.createdBy.username + ']' }}"
                                          required="">
                                </g:select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <div class="row">
                        <div class="col">
                            <g:submitButton class="btn btn-primary" name="createDocument" value="Share"/>
                        </div>

                        <div class="col">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>

