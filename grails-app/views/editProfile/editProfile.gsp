<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Edit Profile</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

</head>

<body>

<g:if test="${flash.success || flash.failure}">
    <div id="alertMessage" class="alert ${flash.failure? 'alert-danger' : 'alert-success'}">
        ${flash.success?: flash.failure}
    </div>
    <script>
        // Automatically hide the alert after 1.5 seconds
        setTimeout(function() {
            $('#alertMessage').fadeOut('slow'); }, 1500);
    </script>
</g:if>


<div class="container">
    <br>
    <tmpl:/dashboard/searchTemplate subscriptions="${subscriptions}"/>
    <br>

    <div class="row d-flex justify-content-between">
        <div class="col-5">
            <tmpl:/dashboard/userActivityTemplate user="${session.user}"/>
            <br>
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col-10 d-flex align-items-center">Topics</div>

                        <div class="col-2 p-1 d-flex justify-content-end">
                            <input type="text" value="${inboxSearch}" class="inboxSearch form-control form-control-sm" placeholder="Search">
                        </div>
                    </div>

                    <input type="text" class="d-none user_id" value="${session.user.id}" name="user_id">

                    <div id="topics-container">
                        %{--  topics will be added here--}%
                    </div>
                    <div class="pagination-container m-1" style="border-bottom: 2px solid black;">
                        <ul class="pagination mb-1 ml-1">
                            <li id="prev-topics" class="page-item"><a class="page-link" href="#">Prev</a></li>
                            <li id="start-topics" class="page-item"><a class="page-link" href="#">Start</a></li>
                            <li id="next-topics" class="page-item"><a class="page-link" href="#">Next</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {
                            let userID = $(".user_id").val()

                            let currentPage = 1; // Track current page
                            // Load resources for initial page
                            loadTopics(currentPage);

                            // Function to load resources for a specific page via AJAX
                            function loadTopics(page) {
                                let inboxSearch = $(".inboxSearch").val()

                                $.ajax({
                                    url: '/Topic/loadTopics',
                                    data: { page: page, user_id: userID, maxPerPage: 10, inboxSearch: inboxSearch},
                                    success: function (data) {
                                        // Render the fetched resources using the GSP template and replace the content of resources-container
                                        $('#topics-container').html(data);

                                        // Update pagination links
                                        updatePaginationLinks(page);
                                    }
                                });
                            }

                            // Function to update pagination links based on current page
                            function updatePaginationLinks(page) {

                                // Disable or enable "Prev" and "Start" links based on current page
                                $('#prev-topics').toggleClass('disabled', page === 1);

                                // Update current page
                                currentPage = page;
                            }

                            // Event handler for pagination links
                            $(document).on('click', '#prev-topics', function (e) {
                                e.preventDefault();
                                if (currentPage > 1) {
                                    currentPage--;
                                    loadTopics(currentPage);
                                }
                            });

                            $(document).on('click', '#start-topics', function (e) {
                                e.preventDefault();
                                currentPage = 1;
                                loadTopics(currentPage);
                            });

                            $(document).on('click', '#next-topics', function (e) {
                                e.preventDefault();
                                currentPage++;
                                // console.log("Next clicked. Current page:", currentPage);
                                loadTopics(currentPage);
                            });

                            // Event handler for input change on search input field
                            $('.inboxSearch').on('input', function() {
                                // Reload search results when the input value changes
                                currentPage = 1;
                                loadTopics(currentPage);
                            });
                        });

                    </script>

                </div>
            </div>
        </div>

        <div class="col-6">
            <div class="row" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Profile</div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="container mt-3">
                                <g:form enctype="multipart/form-data" controller="editProfile" action="edit1" params="[userId: session.user.id]">
                                    <div class="mb-2 row">
                                        <label for="firstName" class="col-4 col-form-label">First Name:</label>

                                        <div class="col-8">
                                            <input type="text" id="firstName" value="${session.user.firstName}"
                                                   class="form-control" name="firstName" required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="lastName" class="col-4 col-form-label">Last Name:</label>

                                        <div class="col-8">
                                            <input type="text" id="lastName" value="${session.user.lastName}"
                                                   class="form-control" name="lastName" required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="username" class="col-4 col-form-label">Username:</label>

                                        <div class="col-8">
                                            <input type="text" id="username" value="${session.user.username}"
                                                   class="form-control" name="username" required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-4 col-form-label">Photo:</label>

%{--                                        <div class="col-8">--}%
%{--                                            <div class="input-group">--}%
%{--                                                <input type="text" class="form-control" id="file-selected2" placeholder="Choose file">--}%
%{--                                                <label class="input-group-text" for="newPhoto">Browse</label>--}%
%{--                                                <input type="file" id="newPhoto" class="form-control d-none" name="newPhoto" onchange="validatePhoto(this)">--}%
%{--                                            </div>--}%
%{--                                            <div id="error-message2" class="invalid-feedback" style="display: none;">Invalid file type. Please choose an image file.</div>--}%
%{--                                        </div>--}%
                                        <div class="col-8">
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="file-selected2" placeholder="Choose file">
                                                <label class="input-group-text" for="newPhoto">Browse</label>
                                                <input type="file" id="newPhoto" class="form-control d-none" name="newPhoto"
                                                       onchange="validatePhoto2(this)">
                                            </div>

                                            <div id="error-message2" class="invalid-feedback"
                                                 style="display: none;">Invalid file type. Please choose an image file.</div>

                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <div class="col"></div>

                                        <div class="col text-end">
                                            <button type="submit" class="btn btn-primary">Update</button>
                                        </div>
                                    </div>
                                </g:form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <br>
            <div class="row" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Change Password</div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="container mt-3">
                                <g:form controller="editProfile" action="edit2" onsubmit="return validatePassword()">
                                    <div class="mb-2 row">
                                        <label for="password" class="col-4 col-form-label">Password:</label>

                                        <div class="col-8">
                                            <input type="password" id="password" class="form-control" name="password" required>
                                            <!-- Error message container -->
                                            <div id="passwordError" class="invalid-feedback"></div>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="confirmPassword" class="col-4 col-form-label">Confirm Password:</label>

                                        <div class="col-8">
                                            <input type="password" id="confirmPassword" class="form-control" name="confirmPassword" required>
                                            <!-- Error message container -->
                                            <div id="confirmPasswordError" class="invalid-feedback"></div>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <div class="col"></div>

                                        <div class="col text-end">
                                            <button type="submit" class="btn btn-primary">Update</button>
                                        </div>
                                    </div>

                                </g:form>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

</div>

<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</body>
</html>