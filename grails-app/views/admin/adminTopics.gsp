<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin [Topic]</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
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

<div class="container" style="padding-top: 20px">

    <br>
    <tmpl:/dashboard/searchTemplate subscriptions="${subscriptions}"/>
    <br>

    <table id="example" class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>Id</th>
            <th>Topicname</th>
            <th>Username</th>
            <th>Visibility</th>
            <th>View Topic</th>
        </tr>
        </thead>
        <tbody>
        <g:each var="topic" in="${allTopicslist}">
            <tr>
                <td>${topic.id}</td>
                <td>${topic.name}</td>
                <td>${topic.createdBy.username}</td>
                <td>${topic.visibility}</td>
                <g:if test="${test.User.findByEmail(session.user.email).admin}">
                    <td>
                        <g:link controller="topicShow" action="index" params="${[topic_id: topic.id]}">${topic.name}</g:link>
                    </td>
                </g:if>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- DataTables JavaScript -->
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
<!-- Bootstrap JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


<script>
    $(document).ready(function () {
        $('#example').DataTable({
            "info": false,
            "pageLength": 20
        });
        $('.dataTables_length').addClass('d-none');

    });
</script>

<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
</body>
</html>