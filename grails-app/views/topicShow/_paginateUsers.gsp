<g:each in="${subscriptions}" var="subscription">
    <div>
        <tmpl:/dashboard/userActivityTemplate user="${subscription.user}"/>
    </div>
</g:each>