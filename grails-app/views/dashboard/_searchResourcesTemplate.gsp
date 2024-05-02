<g:each in="${newPosts}" var="item">
    <div class="row p-1" style="border-bottom: 2px solid black;">
        <tmpl:/dashboard/inboxCardPostTemplate item="${item}"/>
    </div>
</g:each>