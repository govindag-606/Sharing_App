<g:each in="${topicSubs}" var="subscription">
    <div class="row p-0" style="border-bottom: 2px solid black;">
        <tmpl:/dashboard/subscriptionTemplate subscription="${subscription}"/>
    </div>
</g:each>