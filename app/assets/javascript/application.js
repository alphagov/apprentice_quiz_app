//= require govuk_publishing_components/dependencies
//= require govuk_publishing_components/lib
//= require govuk_publishing_components/components/button
//= require rails-ujs
// app/assets/javascripts/application.js

//= require rails-ujs
//= require_tree .

document.addEventListener("DOMContentLoaded", function() {
    var indexContainer = document.getElementById("fade-container");
    if (indexContainer) {
      indexContainer.classList.add("fade-in");
    }
  });
  