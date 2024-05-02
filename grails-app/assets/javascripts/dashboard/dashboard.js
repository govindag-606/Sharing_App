// JS logic for Dashboard/LinkSharing/person-icon
function toggleProfileOptions() {
    let profileOptions = document.getElementById("profile-options");
    profileOptions.classList.toggle("invisible");
}

function validatePhoto(input) {
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif']; // Add more extensions if needed
    const filePath = input.value;
    const fileExtension = filePath.split('.').pop().toLowerCase();

    const isValidExtension = allowedExtensions.includes(fileExtension);
    input.classList.toggle('is-invalid', !isValidExtension);
    document.getElementById('error-message').style.display = isValidExtension ? 'none' : 'block';
    document.getElementById('file-selected').value = isValidExtension ? input.files[0].name : '';
}

function validatePhoto2(input) {
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif']; // Add more extensions if needed
    const filePath = input.value;
    const fileExtension = filePath.split('.').pop().toLowerCase();

    const isValidExtension = allowedExtensions.includes(fileExtension);
    input.classList.toggle('is-invalid', !isValidExtension);
    document.getElementById('error-message2').style.display = isValidExtension ? 'none' : 'block';
    document.getElementById('file-selected2').value = isValidExtension ? input.files[0].name : '';
}


function validatePassword() {
    let passwordInput = document.getElementById('password').value;
    let confirmPasswordInput = document.getElementById('confirmPassword').value;
    let passwordError = document.getElementById('passwordError');
    let confirmPasswordError = document.getElementById('confirmPasswordError');

    // Reset error classes
    document.getElementById('password').classList.remove('is-invalid');
    document.getElementById('confirmPassword').classList.remove('is-invalid');

    // Check if password length is greater than or equal to 8 characters
    if (passwordInput.length < 8) {
        passwordError.innerText = 'Password should be at least 8 characters long.';
        document.getElementById('password').classList.add('is-invalid');
        return false;
    }

    // Check if passwords match
    if (passwordInput !== confirmPasswordInput) {
        confirmPasswordError.innerText = 'Passwords do not match.';
        document.getElementById('confirmPassword').classList.add('is-invalid');
        return false;
    }

    // Validation succeeded
    return true;
}



//  Validate if url is only send from UI
function validateUrlInput() {
    let urlInput = document.getElementById('url').value;
    let urlPattern = /^(ftp|http|https):\/\/[^ "]+$/;

    if (!urlPattern.test(urlInput)) {
        document.getElementById('url').classList.add('is-invalid');
        document.getElementById('urlInputError').innerText = 'Please enter a valid URL.';
        return false;
    } else {
        document.getElementById('url').classList.remove('is-invalid');
        document.getElementById('urlInputError').innerText = '';
        return true;
    }
}


// Edit Topic Name
$(document).ready(function () {


    $('.editIcon').click(function () {
        var topicId = $(this).data('topic-id');
        var dataCard = $(this).closest('.data-card');
        toggleEditMode(dataCard);
    });

    function toggleEditMode(dataCard) {
        var editSection = dataCard.find('.editSection');
        var viewSection = dataCard.find('.viewSection');
        var editInput = editSection.find('.editTopic');
        var saveButton = editSection.find('.saveTopic');
        console.log(editInput.val)

        if (viewSection.is(':visible')) {
            // Switching to edit mode
            viewSection.hide();
            editSection.show();
            editInput.val('');
            editInput.on('input', inputEventListener); // Enable input event listener
            enableEditListeners(editSection); // Enable save and cancel button listeners
        } else {
            // Switching to view mode
            viewSection.show();
            editSection.hide();
            disableEditListeners(editSection); // Disable listeners
        }
    }

    function inputEventListener() {
        var saveButton = $(this).closest('.editSection').find('.saveTopic');
        var editInput = $(this);

        saveButton.prop('disabled', editInput.val().trim() === ''); // Enable/disable save button based on input value
    }

    function enableEditListeners(editSection) {
        editSection.find('.saveTopic').click(saveHandler);
        editSection.find('.cancelButton').click(cancelHandler);
    }

    function disableEditListeners(editSection) {
        editSection.find('.saveTopic').off('click', saveHandler);
        editSection.find('.cancelButton').off('click', cancelHandler);
    }

    function saveHandler(event) {
        var editInput = $(this).closest('.editSection').find('.editTopic');
        if (editInput.val().trim() !== '') {
            toggleEditMode($(this).closest('.data-card')); // Switch back to view mode
        } else {
            event.preventDefault(); // Prevent default form submission if input is empty
        }
    }

    function cancelHandler(event) {
        event.preventDefault(); // Prevent default form submission
        toggleEditMode($(this).closest('.data-card')); // Switch back to view mode
    }
});



