

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>User Profile</title>

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

        <input type="text" class="d-none user_id" value="${user.id}" name="user_id">

        <div class="col-5">

            <tmpl:/dashboard/userActivityTemplate user="${user}"/>

            <br>

            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Topics</div>
                    </div>

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
                                $.ajax({
                                    url: '/Topic/loadTopics',
                                    data: { page: page, user_id: userID, maxPerPage: 5},
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
                        });

                    </script>
                </div>
            </div>

            <br>

            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Subscriptions</div>
                    </div>
                    <div id="subscriptions-container">
                        %{--  topics will be added here--}%
                    </div>
                    <div class="pagination-container m-1" style="border-bottom: 2px solid black;">
                        <ul class="pagination mb-1 ml-1">
                            <li id="prev-subscriptions" class="page-item"><a class="page-link" href="#">Prev</a></li>
                            <li id="start-subscriptions" class="page-item"><a class="page-link" href="#">Start</a></li>
                            <li id="next-subscriptions" class="page-item"><a class="page-link" href="#">Next</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {
                            let userID = $(".user_id").val()

                            let currentPage = 1; // Track current page
                            // Load resources for initial page
                            loadSubscriptions(currentPage);

                            // Function to load resources for a specific page via AJAX
                            function loadSubscriptions(page) {
                                $.ajax({
                                    url: '/Topic/loadSubscriptions',
                                    data: { page: page, user_id: userID},
                                    success: function (data) {
                                        // Render the fetched resources using the GSP template and replace the content of resources-container
                                        $('#subscriptions-container').html(data);

                                        // Update pagination links
                                        updatePaginationLinks(page);
                                    }
                                });
                            }

                            // Function to update pagination links based on current page
                            function updatePaginationLinks(page) {

                                // Disable or enable "Prev" and "Start" links based on current page
                                $('#prev-subscriptions').toggleClass('disabled', page === 1);

                                // Update current page
                                currentPage = page;
                            }

                            // Event handler for pagination links
                            $(document).on('click', '#prev-subscriptions', function (e) {
                                e.preventDefault();
                                if (currentPage > 1) {
                                    currentPage--;
                                    loadSubscriptions(currentPage);
                                }
                            });

                            $(document).on('click', '#start-subscriptions', function (e) {
                                e.preventDefault();
                                currentPage = 1;
                                loadSubscriptions(currentPage);
                            });

                            $(document).on('click', '#next-subscriptions', function (e) {
                                e.preventDefault();
                                currentPage++;
                                // console.log("Next clicked. Current page:", currentPage);
                                loadSubscriptions(currentPage);
                            });
                        });

                    </script>

                </div>
            </div>

        </div>


        <div class="col-6">
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
%{--                        <div class="col">Posts</div>--}%
                        <div class="col-10 d-flex align-items-center">Posts</div>

                        <div class="col-2 p-1 d-flex justify-content-end">
                            <input type="text" value="${inboxSearch}" class="inboxSearch form-control form-control-sm" placeholder="Search">
                        </div>
                    </div>
                    <div id="resources-container">
                        <input type="text" class="d-none topic_id" value="${user.id}" name="user_id">
                        %{--                        resources will be added here--}%
                    </div>
                    <div class="pagination-container m-1" style="border-bottom: 2px solid black;">
                        <ul class="pagination mb-1 ml-1">
                            <li id="prev-resources" class="page-item"><a class="page-link" href="#">Prev</a></li>
                            <li id="start-resources" class="page-item"><a class="page-link" href="#">Start</a></li>
                            <li id="next-resources" class="page-item"><a class="page-link" href="#">Next</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {
                            let userID = $(".user_id").val()

                            let currentPage = 1; // Track current page
                            // Load resources for initial page
                            loadResources(currentPage);

                            // Function to load resources for a specific page via AJAX
                            function loadResources(page) {
                                let inboxSearch = $(".inboxSearch").val()

                                $.ajax({
                                    url: '/Topic/loadResources',
                                    data: { page: page, user_id: userID, inboxSearch: inboxSearch, maxPerPage: 20},
                                    success: function (data) {
                                        // Render the fetched resources using the GSP template and replace the content of resources-container
                                        $('#resources-container').html(data);

                                        // Update pagination links
                                        updatePaginationLinks(page);
                                    }
                                });
                            }

                            // Function to update pagination links based on current page
                            function updatePaginationLinks(page) {

                                // Disable or enable "Prev" and "Start" links based on current page
                                $('#prev-resources').toggleClass('disabled', page === 1);

                                // Update current page
                                currentPage = page;
                            }

                            // Event handler for pagination links
                            $(document).on('click', '#prev-resources', function (e) {
                                e.preventDefault();
                                if (currentPage > 1) {
                                    currentPage--;
                                    loadResources(currentPage);
                                }
                            });

                            $(document).on('click', '#start-resources', function (e) {
                                e.preventDefault();
                                currentPage = 1;
                                loadResources(currentPage);
                            });

                            $(document).on('click', '#next-resources', function (e) {
                                e.preventDefault();
                                currentPage++;
                                // console.log("Next clicked. Current page:", currentPage);
                                loadResources(currentPage);
                            });

                            // Event handler for input change on search input field
                            $('.inboxSearch').on('input', function() {
                                // Reload search results when the input value changes
                                currentPage = 1;
                                loadResources(currentPage);
                            });

                        });

                    </script>
                </div>
            </div>
        </div>

    </div>
    <br>
</div>


<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>

</body>
</html>