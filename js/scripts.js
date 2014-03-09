(function() {
  var khi;

  if (navigator.userAgent.toLowerCase().indexOf('android') > -1) {
    document.documentElement.className += " android";
  }

  khi = angular.module('khi', []);

  khi.config([
    '$provide', function($provide) {
      return $provide.decorator('$rootScope', [
        '$delegate', function($delegate) {
          Object.defineProperty($delegate.constructor.prototype, '$onRootScope', {
            value: function(name, listener) {
              var unsubscribe;
              unsubscribe = $delegate.$on(name, listener);
              return this.$on('$destroy', unsubscribe);
            },
            enumerable: false
          });
          return $delegate;
        }
      ]);
    }
  ]);

  khi.factory('Projects', function() {
    var defaultImg, portPath;
    defaultImg = '/images/code.png';
    portPath = '/images/portfolio/';
    return [
      {
        title: 'Bolster',
        desc: 'Worked with a designer and back-end developer on multiple revisions of the Bolster site and web app.',
        img: portPath + 'bolster.png',
        link: 'http://getbolster.com'
      }, {
        title: 'Keats.me',
        desc: 'My personal website is an ongoing project, where I get to try out cool new technologies without dealing with legacy browsers or client requirements.',
        img: defaultImg,
        github: 'https://github.com/yoshokatana/keats'
      }, {
        title: 'Github Postcommit Shinies',
        desc: 'A little ruby/sinatra project I\'m working on. This app gives you the ability to change labels, add milestones, and reassign github issues via commit message.',
        img: portPath + 'postcommit.png',
        github: 'https://github.com/yoshokatana/github-postcommit-shinies'
      }, {
        title: 'Busker',
        desc: 'Worked with a ruby developer on an independent music webapp. The frontend is built with SpineJS and some cool web audio tech.',
        img: portPath + 'busker.png',
        link: 'http://busker.fm'
      }, {
        title: 'Ringadoc',
        desc: 'Worked with a designer to redesign Ringadoc\'s homepage. Uses some cool css3 hacks on the buttons, and is 100% responsive.',
        img: portPath + 'ringadoc.png',
        link: 'http://www.ringadoc.com/'
      }, {
        title: 'Armenian General Benevolent Union',
        desc: 'Worked with a designer at Barrel to build this responsive wordpress-based website for AGBU. It makes use of multiple feeds, custom post types, and structured templates.',
        img: portPath + 'agbu.png',
        link: 'http://agbu.org/'
      }, {
        title: 'LESS Framework',
        desc: 'Adapted Joni Korpi\'s lessframework with reusable LESS mixins. A little out of date now, but still pretty cool.',
        img: portPath + 'lessframework.png',
        github: 'https://github.com/yoshokatana/LESS-Framework'
      }, {
        title: 'jQuery Geolocation Plugin',
        desc: 'A little plugin I developed to make native geolocation easier. Plugs into Google Maps\' reverse-geocode API and falls back to IP-based lookup on unsupported browsers.',
        img: portPath + 'geolocation.png',
        github: 'https://github.com/yoshokatana/jquery.geolocation'
      }, {
        title: 'Immupure',
        desc: 'Updated the wordpress site of Immupure, redesigning elements and adding new functionality.',
        img: portPath + 'immupure.png',
        link: 'http://www.immupure.com/'
      }
    ];
  });

  khi.factory('FeedService', [
    '$http', '$rootScope', function($http, $rootScope) {
      return {
        posts: null,
        get: function() {
          var me;
          me = this;
          return $http.jsonp('https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=3&callback=JSON_CALLBACK&q=http://blog.keats.me/rss').then(function(res) {
            me.posts = res.data.responseData.feed.entries;
            return $rootScope.$emit('posts.updated');
          });
        }
      };
    }
  ]);

  khi.filter('backgroundimage', function() {
    return function(t) {
      t = t.split('"')[1];
      return t = t.replace(/http/g, 'https');
    };
  });

  khi.filter('trusthtml', [
    '$sce', function($sce) {
      return function(t) {
        return $sce.trustAsHtml(t);
      };
    }
  ]);

  khi.controller('HomePageCtrl', [
    '$scope', 'Projects', 'FeedService', function($scope, Projects, FeedService) {
      $scope.projects = Projects;
      FeedService.get();
      $scope.blogposts = FeedService.posts;
      return $scope.$onRootScope('posts.updated', function() {
        return $scope.blogposts = FeedService.posts;
      });
    }
  ]);

  khi.controller('WorkPageCtrl', [
    '$scope', 'Projects', function($scope, Projects) {
      return $scope.projects = Projects;
    }
  ]);

  khi.controller('ResumePageCtrl', [
    '$scope', function($scope) {
      $scope.jobs = [
        {
          start: 'May 2010',
          end: 'Present',
          place: 'Brooklyn, NY',
          role: 'Freelance Web Designer',
          company: 'Self Employed',
          desc: 'For the past few years, I\'ve been building websites and web apps for freelance clients in San Francisco, New York, and Tokyo. Though I\'m most comfortable with front-end design and development, I\'ve done some full-stack work with Ruby and Nodejs as well as CMS\'s like Drupal, Wordpress, and Shopify',
          subjobs: [
            {
              start: 'July 2013',
              end: 'Present',
              place: 'New York, NY',
              role: 'Front-End Web Developer',
              company: 'Bolster',
              desc: 'I joined Bolster (a startup involved in managing construction projects) as the first front-end developer, and built web applications using AngularJS, LESS, and a grunt-based workflow.'
            }, {
              start: 'Dec. 2012',
              end: 'July 2013',
              place: 'New York, NY',
              role: 'Front-End Web Developer',
              company: 'Busker.fm',
              desc: 'At Busker, a music startup, I built SpineJS-based web apps for consumers, artists, and record labels. I learned a lot about Ruby and Sinatra working with a back-end developer, and cemented my advocacy of non-blocking user interfaces (also known as asynchronous UI) and AGILE development.'
            }, {
              start: 'July 2012',
              end: 'Dec. 2012',
              place: 'New York, NY',
              role: 'Front-End Web Developer',
              company: 'Barrel',
              desc: 'At Barrel, I built responsive websites on Wordpress, Shopify, and other CMS\'s. I also assisted in the development and maintenance of Phonegap-wrapped mobile web apps.'
            }, {
              start: 'March 2011',
              end: 'June 2012',
              place: 'New York, NY',
              role: 'User Experience Engineer',
              company: 'Credit Suisse',
              desc: 'I was part of a three-person development team that built internal and external web apps using ExtJS. We also led mobile web development efforts company-wide, and created and maintained a robust API for client widgets.'
            }, {
              start: 'Oct. 2010',
              end: 'Jan. 2011',
              place: 'New York, NY',
              role: 'SCRUM Master / Drupal Developer',
              company: 'Ology Media',
              desc: 'I developed custom modules for a Drupal-based social networking site, and set up an AGILE development workflow.'
            }
          ]
        }, {
          start: 'Aug. 2008',
          end: 'May 2010',
          place: 'CA and NY',
          role: 'IT Consultant',
          company: 'Self Employed',
          desc: 'Before shifting focus to web design and development, I worked as a freelance IT consultant for small and medium businesses in Rochester, NY and the Bay Area. I focused on networking, troubleshooting, and linux rollouts, and I\'m both Sonicwall and A+ certified.',
          subjobs: [
            {
              start: 'Jan. 2010',
              end: 'May 2010',
              place: 'Rochester, NY',
              role: 'Level III Systems Engineer',
              company: 'Kriterium, LLC',
              desc: 'At Kriterum, I provided IT managed solutions to medium and large business clients. This included traveling to server rollouts along the Eastern Seaboard, compiling technical documentation, and a lot of network cable crimping.'
            }, {
              start: 'Dec. 2009',
              end: 'May 2010',
              place: 'Rochester, NY',
              role: 'Systems Administrator',
              company: 'RIT Center for Computational Relativity and Gravitation',
              desc: 'The RIT CCRG is a small research group that uses supercomputers to model the collisions of galaxies and black holes. I didn\'t work on that directly, but I maintained their webservers, fileservers, backup systems, and website.'
            }, {
              start: 'March 2009',
              end: 'Nov. 2009',
              place: 'Oakland, CA',
              role: 'Technical Support Lead',
              company: 'Maestro Conference',
              desc: 'I joined Maestro Conference as one of their first hires, and set up their support workflow and technical documentation. I sat in on development meetings, and was introduced to both AGILE methodologies and automated testing.'
            }, {
              start: 'Oct. 2008',
              end: 'Jan. 2009',
              place: 'Rochester, NY',
              role: 'Tier 1 Technical Support',
              company: 'Eastman Kodak Company',
              desc: 'I did a brief stint in call-center technical support, and lobbied for Linux driver support for Kodak\'s printers. We all know how that turned out.'
            }
          ]
        }, {
          start: 'March 2008',
          end: 'Aug. 2008',
          place: 'San Ramon, CA',
          role: 'Tier 3 Technical Support',
          company: 'Fask-Teks, Inc.',
          desc: 'At Fast-Teks, I did on-call tech support and hardware/software installation for homes and small businesses. We were also subcontracted by Dell, Inc. to do installation and troubleshooting.'
        }, {
          start: 'July 2006',
          end: 'March 2008',
          place: 'San Ramon, CA',
          role: 'Shift Supervisor / IT Manager',
          company: 'Country Club Cleaners',
          desc: 'I started at this dry cleaners working the front desk, and eventually became the senior customer service employee in charge of two locations and 14 delivery routes. By the end I was assisting the CEO and President with business-level IT decisions and spent most of my time training employees and providing tech support.'
        }, {
          start: 'June 2004',
          end: 'Aug. 2005',
          place: 'Providence, RI',
          role: 'Stock Clerk',
          company: 'Adler\'s Hardware',
          desc: 'Though I\'ve been helping out around the family jewelry store since I was a kid, my first full-time job was at 14. To this day I have no idea how I managed to convince them to let a 14 year old work in a hardware store full of heavy equipment, sharp object, and power tools.'
        }
      ];
      return $scope.interests = [
        {
          img: 'pax_prime_logo.jpg',
          imgAlt: 'Penny Arcade Expo',
          desc: 'I volunteer two times a year at the Penny Arcade Expo. It\'s the largest video- and board-gaming convention in the United States.',
          url: 'http://prime.paxsite.com/what-is-pax'
        }, {
          img: 'shacktac_logo.png',
          imgAlt: 'Shack Tactical',
          desc: 'I play in a large (~170 member) gaming group. We\'ve been featured in PC Gamer, Polygon, and other gaming news media.',
          url: 'http://dslyecxi.com/shacktac_wp/'
        }, {
          img: 'fnpl.png',
          imgAlt: 'Friday Night Party Line',
          desc: 'I\'m a frequent guest on Friday Night Party Line, a monthly roundtable podcast where we discuss news and culture.',
          url: 'http://www.fridaynightpartyline.com/'
        }, {
          img: 'eclipse.jpg',
          imgAlt: 'Boardgames',
          desc: 'I\'m really into European boardgames, and am a fan of indie pen and paper RPGs.',
          url: 'http://www.popsci.com/gadgets/article/2012-02/popsci-qampa-primer-german-style-board-game-revolution'
        }
      ];
    }
  ]);

  khi.controller('ContactSectionCtrl', [
    '$scope', function($scope) {
      return $scope.socialButtons = [
        {
          icon: 'appdotnet',
          service: 'App.net',
          name: '@keats',
          link: 'http://alpha.app.net/keats'
        }, {
          icon: 'twitter',
          service: 'Twitter',
          name: '@yoshokatana',
          link: 'http://twitter.com/yoshokatana'
        }, {
          icon: 'googleplus',
          service: 'Google Plus',
          name: 'Nelson Pecora',
          link: 'https://plus.google.com/+NelsonPecora/about'
        }, {
          icon: 'facebook',
          service: 'Facebook',
          name: 'Yoshokatana',
          link: 'http://facebook.com/yoshokatana'
        }, {
          icon: 'octocat',
          service: 'Github',
          name: 'Yoshokatana',
          link: 'https://github.com/yoshokatana'
        }, {
          icon: 'stackoverflow',
          service: 'Stack Overflow',
          name: 'Yoshokatana',
          link: 'http://stackoverflow.com/users/516719/yoshokatana'
        }, {
          icon: 'tumblr',
          service: 'Blog',
          name: 'blog.keats.me',
          link: 'http://blog.keats.me'
        }, {
          icon: 'pinboard',
          service: 'Pinboard',
          name: 'Yoshokatana',
          link: 'http://pinboard.in/yoshokatana'
        }
      ];
    }
  ]);

}).call(this);
