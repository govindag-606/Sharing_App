<div class="navbar-brand row" style="border: 2px solid black; border-radius: 6px;">
    <div class="col-4 d-flex align-items-center">
        <g:link controller="dashboard" action="index">
            <span class="fw-fold">LinkSharing</span>
        </g:link>
    </div>


    <g:if test="${session.user}">
        <div class="col-3 p-1">
            <g:form controller="search" action="index">
                <div class="input-group">
                    <input type="text" class="form-control" name="key" placeholder="Search">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </g:form>
        </div>

        <div class="col-5 icons gap-1 d-flex align-items-center justify-content-end">
            <g:if test="${isMain}">
                <a class="ui-icon-link" href="#" data-bs-toggle="modal" data-bs-target="#createTopicModal"
                   title="Create Topic">
                    <i class="bi bi-chat-fill fs-4 mr-4 text-dark"></i>
                </a>
                <a class="ui-icon-link" href="#" data-bs-toggle="modal" data-bs-target="#sendInviteModal"
                   title="Send Invite">
                    <i class="bi bi-envelope fs-4 mr-4 text-dark"></i>
                </a>
            </g:if>
            <a class="icon-link" href="#" data-bs-toggle="modal" data-bs-target="#shareLinkModal" title="Share Link">
                <i class="bi bi-link-45deg fs-4 mr-4 text-dark"></i>
            </a>
            <a class="icon-link" href="#" data-bs-toggle="modal" data-bs-target="#shareDocumentModal"
               title="Share Document">
                <i class="bi bi-file-earmark-plus-fill fs-4 mr-4 text-dark"></i>
            </a>

            <!-- Templates for dashboard search modals -->
            <tmpl:/dashboard/search_modals subscriptions="${subscriptions}"/>

            <div class="icon-link" id="profile-dropdown">
                <i class="bi bi-person-fill fs-4 mr-3" style="display: inline-block; vertical-align: middle;"
                   onclick="toggleProfileOptions()"></i>

                <div id="profile-options" class="invisible" style="display: inline-block; vertical-align: middle;">
                    <div class="dropdown">
                        <button class="btn btn-sm dropdown-toggle" type="button" id="dropdownMenuButton"
                                data-bs-toggle="dropdown">
                            <g:if test="${session.user}">
                                ${session.user.firstName}
                            </g:if>
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <li><g:link controller="editProfile" action="index"
                                        class="dropdown-item">Profile</g:link></li>
                            <g:if test="${session.user.admin}">
                                <li><g:link controller="admin" action="users" params="[userId: session.user.id]"
                                            class="dropdown-item">Users</g:link></li>
                                <li><g:link controller="admin" action="topics" params="[userId: session.user.id]"
                                            class="dropdown-item">Topics</g:link></li>
                                <li><g:link controller="admin" action="posts" params="[userId: session.user.id]"
                                            class="dropdown-item">Posts</g:link></li>
                            </g:if>
                            <li><g:link controller="dashboard" action="logout"
                                        class="dropdown-item">Logout</g:link></li>
                        </ul>
                    </div>
                </div>
            </div>
            <!-- JS-Logic for person-icon -->
        </div>
    </g:if>
</div>
