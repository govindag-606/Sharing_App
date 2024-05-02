<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard</title>

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

%{--<g:if test="${flash.success}">--}%
%{--    <div class="alert alert-success">--}%
%{--        ${flash.success}--}%
%{--    </div>--}%
%{--</g:if>--}%
%{--<g:if test="${flash.failure}">--}%
%{--    <div class="alert alert-danger">--}%
%{--        ${flash.failure}--}%
%{--    </div>--}%
%{--</g:if>--}%

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
                        <div class="col">Subscriptions</div>

                        <div class="col d-flex justify-content-end">
                            <a href="#" data-bs-toggle="modal" data-bs-target="#viewAllModal">View All</a>
                        </div>
                        <!-- Scrollable modal -->
                        <tmpl:/dashboard/viewAll_modal viewAll="${viewAll}"/>
                    </div>


                    <g:each in="${subscriptions.take(5)}" var="subscription">
                        <div class="row p-0" style="border-bottom: 2px solid black;">
                            <tmpl:/dashboard/subscriptionTemplate subscription="${subscription}"/>
                        </div>
                    </g:each>

                </div>
            </div>

            <br>

            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Trending Topics</div>
                    </div>
                    <g:each in="${trendTopicSubs}" var="subscription">
                        <g:if test="${subscription.topic.createdBy.username == session.user.username || (subscription.topic.visibility.toString()).equals("Public")}">
                            <div class="row p-0" style="border-bottom: 2px solid black;">
                                <tmpl:/dashboard/subscriptionTemplate subscription="${subscription}"/>
                            </div>
                        </g:if>
                    </g:each>
                </div>
            </div>
        </div>

        <div class="col-6">
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col-10 d-flex align-items-center">Inbox</div>

                        <div class="col-2 p-1 d-flex justify-content-end">
                            <input type="text" value="${inboxSearch}"
                                   class="inboxSearch form-control form-control-sm"
                                   placeholder="Search">
                        </div>
                    </div>
                    <div id="inbox-container">
                        %{--inbox will be added here--}%
                    </div>
                    <div id="pagination-container" class="m-1" style="border-bottom: 2px solid black;">
                        <ul class="pagination mb-1 ml-1">
                            <li class="page-item" id="prev"><a class="page-link" href="#">Prev</a></li>
                            <li class="page-item" id="start"><a class="page-link" href="#">Start</a></li>
                            <li class="page-item" id="next"><a class="page-link" href="#">Next</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {

                            let currentPage = 1; // Track current page
                            // Load resources for initial page
                            loadSearch(currentPage);

                            // Function to load resources for a specific page via AJAX
                            function loadSearch(page) {
                                let inboxSearch = $(".inboxSearch").val()

                                $.ajax({
                                    url: '/Dashboard/loadSearch',
                                    data: {page: page, inboxSearch: inboxSearch},
                                    success: function (data) {
                                        // Render the fetched resources using the GSP template and replace the content of resources-container
                                        $('#inbox-container').html(data);

                                        // Update pagination links
                                        updatePaginationLinks(page);
                                    }
                                });
                            }

                            // Function to update pagination links based on current page
                            function updatePaginationLinks(page) {

                                // Disable or enable "Prev" and "Start" links based on current page
                                $('#prev').toggleClass('disabled', page === 1);

                                // Update current page
                                currentPage = page;
                            }

                            // Event handler for pagination links
                            $(document).on('click', '#prev', function (e) {
                                e.preventDefault();
                                if (currentPage > 1) {
                                    currentPage--;
                                    loadSearch(currentPage);
                                }
                            });

                            $(document).on('click', '#start', function (e) {
                                e.preventDefault();
                                currentPage = 1;
                                loadSearch(currentPage);
                            });

                            $(document).on('click', '#next', function (e) {
                                e.preventDefault();
                                currentPage++;
                                // console.log("Next clicked. Current page:", currentPage);
                                loadSearch(currentPage);
                            });

                            // Event handler for input change on search input field
                            $('.inboxSearch').on('input', function () {
                                // Reload search results when the input value changes
                                currentPage = 1;
                                loadSearch(currentPage);
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</body>
</html>