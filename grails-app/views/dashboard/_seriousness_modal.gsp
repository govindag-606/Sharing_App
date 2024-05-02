<!-- Seriousness Modal -->
<div class="modal fade" id="chooseSeriousnessModal" tabindex="-1" aria-labelledby="chooseSeriousnessModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">

            <g:form controller="subscription" action="subscribe">
                <div class="modal-header pb-1 d-flex align-content-center">
                    <h5 class="modal-title" id="chooseSeriousnessModalLabel">Choose Seriousness Level</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <input type="hidden" name="topic_id" value="${subscription.topic.id}"/>

                <div class="modal-body">
                    <div class="container">
                        <div class="row">
                            <div class="form-group">
                                <g:select class="form-select" name="seriousness" required=""
                                          from="['Serious', 'Very_Serious', 'Casual']"/>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <div class="row">
                        <div class="col">
                            <g:submitButton class="btn btn-primary" name="subscribe" value="Save changes"/>
                        </div>

                        <div class="col">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </g:form>

        </div>
    </div>
</div>
