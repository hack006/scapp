module AdvancedMenu
  ROLES = [:admin, :coach, :player]

  class Menu
    cattr_accessor :name
    cattr_accessor :css_class
    cattr_reader :headings

    @@name
    @@css_class
    @@headings = Array.new()

    def self.add_heading(name, path = nil, controller = nil, action = nil, icon = nil, only_roles = AdvancedMenu::ROLES, classes = [])
      h = Heading.new(name, path, controller, action, icon, only_roles, classes)
      @@headings << h

      yield h if block_given?
    end

    def self.setup
      yield self
    end

    def self.each_permitted_heading(permitted_roles)
      raise Exception, 'Role/s must be provided!' unless permitted_roles || permitted_roles.kind_of?(Array) || permitted_roles.kind_of?(Symbol)
      roles = permitted_roles.kind_of?(Symbol) ? [permitted_roles] : permitted_roles

      @@headings.each_with_index do |h, index|
        unless (h.only_roles & roles).empty?
          yield h
        end
      end
    end

    def self.render(logged_user, controller, action)
      # get roles
      roles = logged_user ? logged_user.roles.map{|r| r.name.to_sym} : :guest

      # activate fields based on controller and action
      @@headings.each do |h|
        h.active = true if h.controller == controller && [nil, action].include?(h.action)
        # replace placeholders
        h.replaced_path = replace_placeholders h.path, logged_user

        h.links.each do |l|
          # replace placeholders
          l.replaced_path = replace_placeholders l.path, logged_user

          if l.controller == controller && [nil, action].include?(l.action)
            l.active = true
            l.parent.active = true unless l.parent.nil?
          end
        end
      end

      # render
      begin
        file = File.open(File.dirname(__FILE__) + '/template.html.haml')
        h = Haml::Engine.new(file.read)
      ensure
        file.close
      end

      h.render Object.new, {menu: self, roles: roles, controller: controller, action: action}
    end

    private

    def self.replace_placeholders(str, user)
      replacements = [{placeholder: '{user_slug}', replacement: user.slug}]
      ret = ""
      replacements.each do |r|
        ret = str.gsub r[:placeholder], r[:replacement]
      end

      ret
    end
  end

  class Heading
    attr_accessor :name, :path, :icon, :active, :replaced_path
    attr_reader :links, :classes, :only_roles, :controller, :action

    def initialize(name, path = nil, controller = nil, action = nil, icon = nil, only_roles = AdvancedMenu::ROLES, classes = [])
      @only_roles = [only_roles] if only_roles.kind_of? Symbol
      @only_roles = only_roles if only_roles.kind_of? Array
      raise Exception, 'Some role must be set!' unless only_roles && @only_roles

      @classes = [classes] if classes.kind_of? String
      @classes = classes if classes.kind_of? Array
      @classes = [] unless @classes

      @name = name
      @path = path
      @controller = controller
      @action = action
      @active = false
      # todo icon can only be array or nil
      @icon = icon
      @links = []
    end

     def add_link(name, path = nil, controller = nil, action = nil, icon = nil, only_roles = AdvancedMenu::ROLES, classes = [])
       l = Link.new(name, path, controller, action, icon, only_roles, classes)
       l.parent = self
       @links << l
     end

    def each_permitted_link(permitted_roles)
      raise Exception, 'Role/s must be provided!' unless permitted_roles || permitted_roles.kind_of?(Array) || permitted_roles.kind_of?(Symbol)
      roles = permitted_roles.kind_of?(Symbol) ? [permitted_roles] : permitted_roles

      @links.each_with_index do |l, index|
        unless (l.only_roles & roles).empty?
          yield l
        end
      end
    end

  end

  class Link
    attr_accessor :name, :path, :icon, :active, :replaced_path
    attr_reader :classes, :only_roles, :controller, :action, :parent

    def initialize(name, path = nil, controller = nil, action = nil, icon = nil, only_roles = AdvancedMenu::ROLES, classes = [])
      @only_roles = [only_roles] if only_roles.kind_of? Symbol
      @only_roles = only_roles if only_roles.kind_of? Array
      raise Exception, 'Some role must be set!' unless only_roles && @only_roles

      @classes = [classes] if classes.kind_of? String
      @classes = classes if classes.kind_of? Array
      @classes = [] unless @classes

      @parent = nil
      @name = name
      @path = path
      @controller = controller
      @action = action
      @active = false
      # todo icon can only be nil or array
      @icon = icon

    end

    def parent=(heading)
      raise Exception, 'Parent must be of type Heading or nil!' unless heading.nil? || heading.kind_of?(Heading)

      @parent = heading
    end

  end

end