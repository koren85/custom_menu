module CustomMenu
  module ApplicationHelperPatch
    def render_project_jump_box_with_custom_menu
      unless acl_mobile_device?
        super
      end
    end

    def javascript_include_tag_with_custom_menu(*sources)
      return super(*sources) if !(Setting.plugin_custom_menu || {})['use_custom_menu'] || (sources.last.is_a?(Hash) && sources.last[:plugin].present?)

      sources = sources - ['responsive', :responsive, 'responsive.js']
      super(*sources)
    end

    def self.prepended(base)
      base.send :prepend, InstanceMethods
    end

    module InstanceMethods
      def render_project_jump_box
        render_project_jump_box_with_custom_menu
      end

      def javascript_include_tag(*sources)
        javascript_include_tag_with_custom_menu(*sources)
      end
    end
  end
end

ApplicationHelper.prepend CustomMenu::ApplicationHelperPatch
