export function rating_home() {
  $("#rating_button").click(function() {
    $("#box form").toggle("slow");
    return false;
  });
}