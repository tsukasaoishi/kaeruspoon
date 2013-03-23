(function(){

  function ParameterMissing(message) {
   this.message = message;
  }
  ParameterMissing.prototype = new Error(); 

  var defaults = {
    prefix: '',
    default_url_options: {}
  };

  var NodeTypes = {"GROUP":1,"CAT":2,"SYMBOL":3,"OR":4,"STAR":5,"LITERAL":6,"SLASH":7,"DOT":8};
  
  var Utils = {

    serialize: function(obj){
      if (!obj) {return '';}
      if (window.jQuery) {
        var result = window.jQuery.param(obj);
        return !result ? "" : "?" + result
      }
      var s = [];
      for (prop in obj){
        if (obj[prop]) {
          if (obj[prop] instanceof Array) {
            for (var i=0; i < obj[prop].length; i++) {
              key = prop + encodeURIComponent("[]");
              s.push(key + "=" + encodeURIComponent(obj[prop][i].toString()));
            }
          } else {
            s.push(prop + "=" + encodeURIComponent(obj[prop].toString()));
          }
        }
      }
      if (s.length === 0) {
        return '';
      }
      return "?" + s.join('&');
    },

    clean_path: function(path) {
      path = path.split("://");
      var last_index = path.length - 1;
      path[last_index] = path[last_index].replace(/\/+/g, "/").replace(/\/$/m, '');
      return path.join("://");
    },

    set_default_url_options: function(optional_parts, options) {
      for (var i=0;i < optional_parts.length; i++) {
        var part = optional_parts[i];
        if (!options.hasOwnProperty(part) && defaults.default_url_options.hasOwnProperty(part)) {
          options[part] = defaults.default_url_options[part];
        }
      }
    },

    extract_anchor: function(options) {
      var anchor = options.hasOwnProperty("anchor") ? options.anchor : null;
      delete options.anchor;
      return anchor ? "#" + anchor : "";
    },

    extract_options: function(number_of_params, args) {
      if (args.length > number_of_params) {
        return typeof(args[args.length-1]) == "object" ?  args.pop() : {};
      } else {
        return {};
      }
    },

    path_identifier: function(object) {
      if (object === 0) {
        return '0';
      }

      if (! object) { // null, undefined, false or ''
        return '';
      }

      if (typeof(object) == "object") {
        var property = object.to_param || object.id || object;
        if (typeof(property) == "function") {
          property = property.call(object)
        }
        return property.toString();
      } else {
        return object.toString();
      }
    },

    clone: function (obj) {
      if (null == obj || "object" != typeof obj) return obj;
      var copy = obj.constructor();
      for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
      }
      return copy;
    },

    prepare_parameters: function(required_parameters, actual_parameters, options) {
      var result = this.clone(options) || {};
      for (var i=0; i < required_parameters.length; i++) {
        result[required_parameters[i]] = actual_parameters[i];
      }
      return result;
    },

    build_path: function(required_parameters, optional_parts, route, args) {
      args = Array.prototype.slice.call(args);
      var opts = this.extract_options(required_parameters.length, args);
      if (args.length > required_parameters.length) {
        throw new Error("Too many parameters provided for path");
      }

      var parameters = this.prepare_parameters(required_parameters, args, opts);
      this.set_default_url_options(optional_parts, parameters);
      var result = Utils.get_prefix();
      var anchor = Utils.extract_anchor(parameters);

      result += this.visit(route, parameters)
      return Utils.clean_path(result + anchor) + Utils.serialize(parameters);
    },

    /*
     * This function is JavaScript impelementation of the
     * Journey::Visitors::Formatter that builds route by given parameters
     * from route binary tree.
     * Binary tree is serialized in the following way:
     * [node type, left node, right node ]
     *
     * @param  {Boolean} optional  Marks the currently visited branch as optional. 
     *   If set to `true`, this method will not throw when encountering 
     *   a missing parameter (used in recursive calls).
     */
    visit: function(route, parameters, optional) {
      var type = route[0];
      var left = route[1];
      var right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return this.visit(left, parameters, true)
        case NodeTypes.STAR:
          return this.visit(left, parameters, true)
        case NodeTypes.CAT:
          var leftPart = this.visit(left, parameters, optional),
              rightPart = this.visit(right, parameters, optional);

          if (optional && ! (leftPart && rightPart))
            return '';

          return leftPart + rightPart;
        case NodeTypes.LITERAL:
          return left;
        case NodeTypes.SLASH:
          return left;
        case NodeTypes.DOT:
          return left;
        case NodeTypes.SYMBOL:
          var value = parameters[left];

          if (value || value === 0) {
            delete parameters[left];
            return this.path_identifier(value);
          }

          if (optional) {
            return '';  // missing parameter
          } else {
            throw new ParameterMissing("Route parameter missing: " + left);
          }
        /*
         * I don't know what is this node type
         * Please send your PR if you do
         */
        //case NodeTypes.OR:
        default:
          throw new Error("Unknown Rails node type");
      }
    },

    get_prefix: function(){
      var prefix = defaults.prefix;

      if( prefix !== "" ){
        prefix = prefix.match('\/$') ? prefix : ( prefix + '/');
      }
      
      return prefix;
    },

    namespace: function (root, namespaceString) {
        var parts = namespaceString ? namespaceString.split('.') : [];
        if (parts.length > 0) {
            current = parts.shift();
            root[current] = root[current] || {};
            Utils.namespace(root[current], parts.join('.'));
        }
    }
  };

  Utils.namespace(window, 'Routes');
  window.Routes = {
// article => /articles/:id(.:format)
  article_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"articles",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// articles => /articles(.:format)
  articles_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"articles",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// date_articles => /articles/date/:year/:month(/:day)(.:format)
  date_articles_path: function(_year, _month, options) {
  return Utils.build_path(["year","month"], ["day","format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"articles",false]],[7,"/",false]],[6,"date",false]],[7,"/",false]],[3,"year",false]],[7,"/",false]],[3,"month",false]],[1,[2,[7,"/",false],[3,"day",false]],false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_article => /articles/:id/edit(.:format)
  edit_article_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"articles",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_article => /articles/new(.:format)
  new_article_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"articles",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info => /rails/info(.:format)
  rails_info_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info_properties => /rails/info/properties(.:format)
  rails_info_properties_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[7,"/",false]],[6,"properties",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info_routes => /rails/info/routes(.:format)
  rails_info_routes_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[7,"/",false]],[6,"routes",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// root => /
  root_path: function(options) {
  return Utils.build_path([], [], [7,"/",false], arguments);
  }}
;
  window.Routes.options = defaults;
})();
