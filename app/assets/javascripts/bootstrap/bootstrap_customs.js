$(function() {
    if (apply_select) {
        $('select').each(function() {
            $(this).select2();
        });
    }
    $(".date").datepicker({
        dateFormat: 'dd/mm/yyyy',
        weekStart: 1,
        autoclose: true
    });
});