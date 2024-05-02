<%@ page import="test.ResourceRating" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Post</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <style>
    .stars {
        font-size: 20px;
        cursor: pointer;
    }
    </style>

</head>

<body>

<div class="container">
    <br>
    <tmpl:/dashboard/searchTemplate subscriptions="${subscriptions}"/>
    <br>

    <div class="row d-flex justify-content-between">
        <div class="col-6">
            <br>

            <div class="row p-2" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row">
                        <div class="col-2 align-content-start">
                            <g:link controller="userProfileController" action="index">
                                <asset:image src="homepage/person-square.png" class="img-fluid" alt="person-photo"/>
                            </g:link>
                        </div>

                        <div class="col-5">
                            <div class="row">${resource.topic.createdBy.name}</div>
                            <small class="row text-muted">
                                <g:link controller="userProfile" action="index" params="[username: resource.topic.createdBy.username]">
                                    ${resource.topic.createdBy.username}
                                </g:link>
                            </small>
                        </div>

                        <div class="col-5">
                            <div class="row justify-content-end">
                                <div class="col-auto">
                                    <g:link controller="topicShow" action="index" params="[topic_id: resource.topic.id]">
                                        <small class="text-end">${resource.topic.name}</small>
                                    </g:link>
                                </div>
                            </div>

                            <% def ratings = test.ResourceRating.findAllByResource(resource) %>
                            <% def ratingsNo = ratings.size() %>
                            <g:if test="${ratings}">
                                <div class="row justify-content-end">
                                    <div class="col-auto">
                                        <%
                                            def date = ratings.max({ it.lastUpdated }).lastUpdated
                                            String formattedDate = new SimpleDateFormat("h:mm a dd MMM yyyy", Locale.ENGLISH).format(date)
                                        %>
                                        <small>${formattedDate}</small>
                                    </div>
                                </div>
                            </g:if>

                            <div class="row justify-content-end">
                                <div class="col-auto">
                                    <div class="stars" id="stars">
                                        <span class="star" data-value="1">★</span>
                                        <span class="star" data-value="2">★</span>
                                        <span class="star" data-value="3">★</span>
                                        <span class="star" data-value="4">★</span>
                                        <span class="star" data-value="5">★</span>&nbsp;
                                        <span id="ratingsNo" class="small text-muted">[${ratingsNo}]</span>
                                    </div>
                                </div>
                            </div>

                            <div class="row justify-content-end">
                                <div class="col-auto">
                                    <small id="avgRating">Avg Rating: ${avgRating}</small>
                                </div>
                            </div>

                            <script>
                                $(document).ready(function () {
                                    // Assume userRating is set from the server-side to a value between 0 and 5
                                    let userRating = +'${userRating}'; // Example rating
                                    // Get all the stars
                                    let stars = $('.star');
                                    let sessionUser = '${session.user}'; // Assuming session.user holds the user information

                                    // Function to update the stars based on userRating
                                    function updateStars(userRating) {
                                        stars.each(function (i) {
                                            if (i < userRating) {
                                                $(this).addClass('filled text-warning');
                                            } else {
                                                $(this).removeClass('filled text-warning');
                                            }
                                        });
                                    }

                                    // Call the function to initially update the stars
                                    updateStars(userRating);

                                    // Click event handler for stars (conditionally enabled)
                                    $(".star").click(function () {
                                        if (sessionUser !== '') { // Check if session user is not null (as string)
                                            userRating = $(this).index() + 1;
                                            updateStars(userRating);

                                            // Make AJAX request to update the resource rating
                                            $.ajax({
                                                url: '/ResourceRating/updateResourceRating',
                                                type: 'POST',
                                                data: {
                                                    score: userRating,
                                                    resource_id: ${resource.id}
                                                },
                                                success: function (response) {
                                                    let avgRating = +response.avgRating
                                                    let ratingsNo = +response.ratingsNo
                                                    $('#avgRating').text('Avg Rating: ' + avgRating)
                                                    $('#ratingsNo').text('[' + ratingsNo + ']')
                                                },
                                                error: function (xhr, status, error) {
                                                    console.error(status + ': ' + error);
                                                }
                                            });
                                        }
                                    });

                                });
                            </script>

                        </div>

                    </div>

                    <div class="row pr-2 pt-2 pb-2">
                        <div class="col">${resource.description}</div>
                    </div>

                    <small class="row">
                        <div class="col-7">
                            <a href="https://www.facebook.com"><i class="bi bi-facebook"></i></a>
                            <a href="https://www.whatsapp.com"><i class="bi bi-whatsapp"></i></a>
                            <a href="https://www.instagram.com"><i class="bi bi-instagram"></i></a>
                        </div>
                        <g:if test="${session.user && session.user.username == resource.topic.createdBy.username}">
                            <div class="col-2 d-flex justify-content-end">
                                <g:link action="deleteResource" controller="post" params="[resource_id: resource.id]">Delete</g:link>
                            </div>

                            <div class="col-1 d-flex justify-content-end">
                                <g:if test="${resource.linkResource}">
                                    <a href="#" class="ui-icon-link" data-bs-toggle="modal"
                                       data-bs-target="#editLinkModal">
                                        Edit
                                    </a>
                                    <!--Edit Link Modal -->
                                    <div class="modal fade" id="editLinkModal" tabindex="-1"
                                         aria-labelledby="editLinkModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <g:form controller="post" action="editPost" params="[resource_id: resource.id]">
                                                    <div class="modal-header pb-1 d-flex align-content-center">
                                                        <h5 class="modal-title" id="editLinkModalLabel">Edit Post: "${resource.topic.name}"</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>

                                                    <div class="modal-body">
                                                        <div class="container">
                                                            <div class="row mb-4">
                                                                <label class="col-4 col-form-label" for="url">Link:</label>
                                                                <div class="col-8">
                                                                    <g:textField class="form-control small" value ="${resource.linkResource.url}"
                                                                                 name="url" type="url" required=""/>
                                                                    <div id="urlInputError" class="invalid-feedback"></div>
                                                                </div>
                                                            </div>

                                                            <div class="row mb-4">
                                                                <label class="col-4 col-form-label"
                                                                       for="description">Description:</label>

                                                                <div class="col-8">
                                                                    <g:textArea class="form-control" name="description"
                                                                                value="${resource.description}"
                                                                                type="text" required=""/>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="modal-footer">
                                                        <div class="row">
                                                            <div class="col">
                                                                <g:submitButton class="btn btn-primary" name="EditLink" value="Edit"/>
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
                                </g:if>

                                <g:else>
                                    <a href="#" class="ui-icon-link" data-bs-toggle="modal" data-bs-target="#editDocumentModal">
                                        Edit
                                    </a>
                                    <!--Share Document Modal -->
                                    <div class="modal fade" id="editDocumentModal" tabindex="-1" aria-labelledby="editDocumentModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <g:form controller="post" action="editPost" enctype="multipart/form-data"  params="[resource_id: resource.id]">
                                                    <div class="modal-header pb-1 d-flex align-content-center">
                                                        <h5 class="modal-title" id="editDocumentModalLabel">Edit Post: "${resource.topic.name}"</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                                aria-label="Close"></button>
                                                    </div>

                                                    <div class="modal-body">
                                                        <div class="container">
                                                            <div class="row mb-4">
                                                                <label class="col-4 col-form-label">Document:</label>

                                                                <div class="col-8">
                                                                    <div class="input-group">
                                                                        <input type="text" class="form-control" id="edit-file-selected" placeholder="Choose File">
                                                                        <label class="input-group-text" for="edit_filePath">Browse</label>
                                                                        <input type="file" id="edit_filePath" class="form-control d-none" name="edit_filePath" required=""
                                                                               onchange="document.getElementById('edit-file-selected').value = this.files[0].name">
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="row mb-4">
                                                                <label class="col-4 col-form-label" for="description">Description:</label>

                                                                <div class="col-8">
                                                                    <g:textArea class="form-control" name="description"
                                                                                value="${resource.description}" type="text" required=""/>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="modal-footer">
                                                        <div class="row">
                                                            <div class="col">
                                                                <g:submitButton class="btn btn-primary" name="EditDocument" value="Edit"/>
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
                                </g:else>
                            </div>
                        </g:if>
                        <g:if test ="${session.user}">
                            <div class="col d-flex justify-content-end">
                                <g:if test="${resource.linkResource}">
                                    <a href="${resource.linkResource.url}" target="_blank">View site</a>
                                </g:if>
                                <g:else>
%{--                                    <g:link controller="dashboard" action="download" target="_blank"--}%
%{--                                            params="[filePath: resource.documentResource.filePath]">--}%
%{--                                        Download--}%
%{--                                    </g:link>--}%
                                    <a href="/assets/${resource.documentResource.filePath}" target="_blank" download="File">
                                        Download
                                    </a>
                                </g:else>
                            </div>
                        </g:if>
                    </small>
                </div>
            </div>

        </div>
        <g:if test="${session.user}">
            <div class="col-5">
                <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                    <div class="col">
                        <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                            <div class="col">Trending Topics</div>
                        </div>
                        <g:each in="${trendTopics}" var="subscription">
                            <div class="row p-0" style="border-bottom: 2px solid black;">
                                <tmpl:/dashboard/subscriptionTemplate subscription="${subscription}"/>
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>
        </g:if>
        <g:else>
            <div class="col-5">

                <!-- LogIn Box -->
                <div class="row" style="border: 2px solid black; border-radius: 6px;">
                    <div class="col">
                        <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                            <div class="col">Login</div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <div class="container mt-3">
                                    <g:form controller="authentication" action="login">
                                        <div class="row mb-3">
                                            <label for="emailOrUsername" class="col-4 col-form-label">Email/Username:</label>
                                            <div class="col-8">
                                                <g:textField id="emailOrUsername" class="form-control" name="emailOrUsername" required=""/>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <label for="password" class="col-4 col-form-label">Password:</label>
                                            <div class="col-8">
                                                <g:passwordField class="form-control" name="password" required=""/>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-6 text-start">
                                                <a href="#">Forgot password?</a>
                                            </div>
                                            <div class="col-6 text-end">
                                                <g:submitButton class="btn btn-primary" name="login" value="login"/>
                                            </div>
                                        </div>
                                    </g:form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <br>

                <!-- Register Box -->
                <div class="row" style="border: 2px solid black; border-radius: 6px;">
                    <div class="col">
                        <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                            <div class="col">Register</div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <div class="container mt-2">
                                    <g:form class="login-form" enctype="multipart/form-data" id="registerForm" controller="authentication" action="register" method="post">
                                        <div class="mb-2 row">
                                            <label for="firstName" class="col-4 col-form-label">First Name:</label>
                                            <div class="col-8">
                                                <input type="text" id="firstName" class="form-control" name="firstName" required>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <label for="lastName" class="col-4 col-form-label">Last Name:</label>
                                            <div class="col-8">
                                                <input type="text" id="lastName" class="form-control" name="lastName" required>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <label for="email" class="col-4 col-form-label">Email:</label>
                                            <div class="col-8">
                                                <input type="email" id="email" class="form-control" name="email" required>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <label for="username" class="col-4 col-form-label">Username:</label>
                                            <div class="col-8">
                                                <input type="text" id="username" class="form-control" name="username" required>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <label for="password" class="col-4 col-form-label">Password:</label>
                                            <div class="col-8">
                                                <input type="password" id="password" class="form-control" name="password" required>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <label for="confirmPassword" class="col-4 col-form-label">Confirm Password:</label>
                                            <div class="col-8">
                                                <input type="password" id="confirmPassword" class="form-control" name="confirmPassword" required>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <label class="col-4 col-form-label">Photo:</label>
                                            <div class="col-8">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" id="file-selected" placeholder="Choose file">
                                                    <label class="input-group-text" for="photo">Browse</label>
                                                    <input type="file" id="photo" class="form-control d-none" name="photo" onchange="document.getElementById('file-selected').value = this.files[0].name">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mb-2 row">
                                            <div class="col text-end">
                                                <button type="submit" class="btn btn-primary">Register</button>
                                            </div>
                                        </div>
                                    </g:form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </g:else>
    </div>
    <br>
</div>


<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script></body>
</html>