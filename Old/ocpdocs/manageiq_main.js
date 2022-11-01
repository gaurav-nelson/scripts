(function() {
    var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  
    this.miq || (this.miq = {
      ui: {}
    });
  
    miq.select = function(selector) {
      if (selector == null) {
        selector = "body";
      }
      return document.querySelector(selector);
    };
  
    miq.setup_header_ani = function() {
      miq.header = miq.select(".site-header");
      miq.triad = miq.select(".triad");
      miq.title = miq.select(".banner h1");
      miq.fade_offset = miq.header.offsetHeight;
      miq.fade_start = miq.fade_offset / 2;
      miq.fade_stop = miq.triad.offsetTop + miq.triad.offsetHeight;
      miq.fade_diff = (miq.fade_stop - miq.fade_start) / 1.8;
      miq.header_pad = parseInt($(miq.header).css('padding-top'));
      miq.scale_start = miq.header.offsetHeight;
      miq.scale_stop = miq.fade_stop;
      miq.scale_diff = (miq.scale_stop - miq.fade_start) * 1.1;
      return miq.last_scroll_y = -1;
    };
  
    miq.fade_header = function() {
      var end_color, end_values, opac, start_color, start_values;
      if (miq.last_scroll_y > miq.fade_start && miq.last_scroll_y < miq.fade_stop) {
        opac = miq.last_scroll_y / miq.fade_diff;
      } else if (miq.last_scroll_y < miq.fade_start) {
        opac = 0;
      } else if (miq.last_scroll_y > miq.fade_stop) {
        opac = 1;
      }
      start_values = [6, 52, 81, opac];
      end_values = [12, 105, 165, opac];
      start_color = "rgba(" + (start_values.join()) + ")";
      end_color = "rgba(" + (end_values.join()) + ")";
      return miq.header.style.backgroundImage = "linear-gradient(to right, " + start_color + " 0, " + end_color + " 100%)";
    };
  
    miq.scale_header = function() {
      var divider, pad;
      if (miq.last_scroll_y > miq.scale_start && miq.last_scroll_y < miq.scale_stop) {
        divider = 1 + (miq.last_scroll_y / miq.scale_diff);
      } else if (miq.last_scroll_y < miq.scale_start) {
        divider = 1;
      } else if (miq.last_scroll_y > miq.scale_stop) {
        divider = 2;
      }
      pad = miq.header_pad / divider;
      miq.header.style.paddingTop = pad + "px";
      return miq.header.style.paddingBottom = pad + "px";
    };
  
    miq.on_scroll = function() {
      return miq.update_background();
    };
  
    miq.update_background = function() {
      if (miq.last_scroll_y === window.scrollY) {
        requestAnimationFrame(miq.update_background);
        return false;
      } else {
        miq.last_scroll_y = window.scrollY;
      }
      miq.animate_header();
      return requestAnimationFrame(miq.update_background);
    };
  
    miq.animate_header = function() {
      miq.fade_header();
      return miq.scale_header();
    };
  
    $(document).ready(function() {
      if ($(".triad").length > 0) {
        miq.setup_header_ani();
        miq.scale_header();
        return window.addEventListener("scroll", miq.on_scroll);
      }
    });
  
    $(document).ready(function() {
      return $('[data-behavior="off_canvas-toggle"]').on('click', function() {
        return $('body').toggleClass('off_canvas-visible');
      });
    });
  
    miq.open_active = function() {
      return $("li.active").parents("li").each(function(i, elem) {
        return $(elem).addClass("menu-open");
      });
    };
  
    $(document).ready(function() {
      if ($(".menu-parent").length > 0) {
        miq.open_active();
        return $(document).on("click", ".menu-parent > a", function(e) {
          $(this).parent("li.menu-parent").toggleClass("menu-open");
          return e.preventDefault();
        });
      }
    });
  
    this.miq || (this.miq = {});
  
    miq.LightboxImg = (function() {
      function LightboxImg(elem) {
        this.element = $(elem);
        this.bindEvents();
      }
  
      LightboxImg.prototype.bindEvents = function() {
        return this.element.on('click', function() {
          return miq.lightbox.display(this.src, this.alt);
        });
      };
  
      return LightboxImg;
  
    })();
  
    miq.Lightbox = (function() {
      function Lightbox(boxDiv) {
        this.bindEvents = bind(this.bindEvents, this);
        this.box = $(boxDiv);
        this.title = this.box.find('.lightbox-title');
        this.titleText = "Enlarged Image";
        this.closeBtn = this.box.find('.lightbox-close');
        this.image = this.box.find('.lightbox-image > img');
        this.bindEvents();
      }
  
      Lightbox.prototype.display = function(imgSrc, text) {
        if (text == null) {
          text = '';
        }
        this.image.attr('src', imgSrc);
        if (text.length > 0) {
          this.title.text(text);
        }
        $('body').addClass('js-no_scroll');
        $('.lightbox-image').removeClass('lightbox-full');
        return this.box.addClass('js-display');
      };
  
      Lightbox.prototype.close = function() {
        this.box.removeClass('js-display');
        return $('body').removeClass('js-no_scroll');
      };
  
      Lightbox.prototype.bindEvents = function() {
        this.closeBtn.on('click', (function(_this) {
          return function() {
            return _this.close();
          };
        })(this));
        this.box.on('click', (function(_this) {
          return function(e) {
            return _this.close();
          };
        })(this));
        return this.image.on('click', function(e) {
          e.stopPropagation();
          return $('.lightbox-image').toggleClass('lightbox-full');
        });
      };
  
      return Lightbox;
  
    })();
  
    $(document).ready(function() {
      var elem, j, len, ref;
      miq.boxImgs = [];
      ref = $('.large_img');
      for (j = 0, len = ref.length; j < len; j++) {
        elem = ref[j];
        miq.boxImgs.push(new miq.LightboxImg(elem));
      }
      return miq.lightbox = new miq.Lightbox('#lightbox');
    });
  
  }).call(this);
