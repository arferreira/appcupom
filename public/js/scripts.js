$(document).ready(function () {

    "use strict";

    jQuery.fn.doesExist = function () {
        return jQuery(this).length > 0;
    };

    $('#home-slider').flexslider({
        controlNav: false
    });

    $('.work-slider').flexslider({
        controlNav: false
    });

    ////////// Mobile Responsive Menu

    $('#mobile-toggle').click(function () {

        if ($('#main-nav').hasClass('menu-open')) {

            $('#main-nav').removeClass('menu-open');

        } else {

            $('#main-nav').addClass('menu-open');

        }

    });

    // toggle-buttons

    $('.toggle-buttons .title').click(function () {

        if ($(this).siblings('.text').hasClass('toggle-buttons-expanded')) {
            $(this).siblings('.text').removeClass('toggle-buttons-expanded');
            $(this).children('.minus').hide();
            $(this).children('.plus').show();
        } else {
            $(this).siblings('.text').addClass('toggle-buttons-expanded');
            $(this).children('.minus').show();
            $(this).children('.plus').hide();
        }


    });

    $('.service').click(function () {


        if ($(this).children('.s-body').hasClass('service-open')) {
            $(this).children('.s-body').removeClass('service-open');
        } else {
            $(this).children('.s-body').addClass('service-open');
        }


    });

    // Initialize Smooth Scroll (for back to top button)

    $(".back-to-top").click(function () {
        $("html, body").animate({
            scrollTop: 0
        }, "slow");
        return false;
    });

    // Initialize Masonry Layouts

    if ($('#threecol-container').doesExist()) {
        $('#threecol-container').isotope({

            itemSelector: '.work-item',
            layoutMode: 'fitRows'

        });
    }

    $('#threecol-filters a').click(function () {
        $('#threecol-filters li').removeClass('active-filter');
        $(this).parent().addClass('active-filter');
        var selector = $(this).attr('data-filter');
        $('#threecol-container').isotope({
            filter: selector
        });
        return false;

    });


    if ($('#threecol-container').doesExist()) {
        $('#twocol-container').isotope({

            itemSelector: '.work-item',
            layoutMode: 'fitRows'

        });
    }

    $('#twocol-filters a').click(function () {
        $('#threecol-filters li').removeClass('active-filter');
        $(this).parent().addClass('active-filter');
        var selector = $(this).attr('data-filter');
        $('#twocol-container').isotope({
            filter: selector
        });
        return false;

    });

    setTimeout(function () {
        $('.trigger').trigger('click');
    }, 500);


    // Work Item Hovers

    $('.work-img-preview').mouseenter(function () {

        $(this).children('.work-overlay').show();


    });

    $('.work-img-preview').mouseleave(function () {

        $(this).children('.work-overlay').hide();

    });


    // Blog Item Hovers

    $('.front-blog-img').mouseenter(function () {

        $(this).children('.work-overlay').show();


    });

    $('.front-blog-img').mouseleave(function () {

        $(this).children('.work-overlay').hide();

    });


    // Feature Panel

    $('.selector').click(function () {

        var panelName = $(this).attr('data-panel-id');
        var panelID = '#' + $(this).attr('data-panel-id');
        var oldActive = '#' + $('.lower .active').attr('id');

        if (!$(panelID).hasClass('active')) {

            $('.arrow-down').removeClass('active');
            $('.arrow-down[data-panel-id="' + panelName + '"]').addClass('active');


            $(oldActive).removeClass('active');


            $(panelID).addClass('animated fadeInUp active');
            setTimeout(function () {
                $(panelID).removeClass('fadeInUp');
            }, 1000);

        }

    });

   ////////// Contact Form Code

    //Contact Form Code:
    $(function () {
        $(".form-button").click(function (e) {
            var $error = 0;
            var name = $("#form-name").val();
            var email = $("#form-email").val();
            var text = $("#form-msg").val();
            var security = $("#form-security").val();


            if (name === "" || email === "" || text === "") {
                $('#details-error-wrap').fadeIn(1000);
                $error = 1;

            } else {
                $('#details-error-wrap').fadeOut(1000);
            }

            if (security !== '8') {
                $('#security-error-wrap').fadeIn(1000);
                $error = 1;

            } else {
                $('#security-error-wrap').fadeOut(1000);
            }

            if (!(/(.+)@(.+){2,}\.(.+){2,}/.test(email))) {
              
                $('#details-error-wrap').fadeIn(1000);
                $error = 1;
            }



            var dataString = 'name=' + name + '&email=' + email + '&text=' + text;

            if ($error === 0) {
                $.ajax({
                    type: "POST",
                    url: "mail.php",
                    data: dataString,
                    success: function () {
                        $('#details-error-wrap').fadeOut(1000);
                        $('#security-error-wrap').fadeOut(1000);
                        $('#form-sent').fadeIn(1000);
                    }
                });
                return false;
            }

            e.preventDefault();
        });
    });




});