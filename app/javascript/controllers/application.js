import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

$(document).ready(function() {
  console.log('Script is running');
  setTimeout(function() {
    console.log('Fading out');
    $('#notice').fadeOut('slow');
  }, 5000);
});

$(document).ready(function() {
  console.log('Script is running');
  setTimeout(function() {
    console.log('Fading out');
    $('#alert').fadeOut('slow');
  }, 5000);
});


document.addEventListener("DOMContentLoaded", function() {
  const filterForm = document.getElementById('filter-form');
  const filterCheckboxes = document.querySelectorAll('.filter-checkbox');

  filterCheckboxes.forEach(checkbox => {
    checkbox.addEventListener('change', function() {
      filterForm.submit();
    });
  });
});
