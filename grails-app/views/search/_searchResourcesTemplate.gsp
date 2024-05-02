<g:each in="${resources}" var="resource">
    <div class="row p-1" style="border-bottom: 2px solid black;">
        <tmpl:/topicShow/inboxCardPostTemplate resource="${resource}"/>
    </div>
</g:each>