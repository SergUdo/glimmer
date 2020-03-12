require "spec_helper"

describe "Glimmer Color" do
  include Glimmer

  before do
    dsl :swt
  end

	after do
		@target.display.dispose if @target.display
	end

  it "tests label with RGBAlpha background color" do
    @target = shell {
      @label = label {
        background rgba(4, 40, 244, 50)
      }
    }

    color = @label.widget.getBackground
    expect(color.getRed).to eq(4)
    expect(color.getGreen).to eq(40)
    expect(color.getBlue).to eq(244)
    expect(color.getAlpha).to eq(50)
  end

  it "tests label with RGB (no alpha) background color" do
    @target = shell {
      @label = label {
        background rgb(4, 40, 244)
      }
    }

    color = @label.widget.getBackground
    expect(color.getRed).to eq(4)
    expect(color.getGreen).to eq(40)
    expect(color.getBlue).to eq(244)
  end

  # Standard colors: not an exhaustive list. Sample taken from here: https://help.eclipse.org/2019-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html
  %i[
    color_black
    color_blue
    color_cyan
    color_green
    color_magenta
    color_red
    color_white
    color_yellow
  ].each do |standard_color|
    it "tests label with standard #{standard_color} background color passed as a Ruby symbol" do
      @target = shell {
        @label = label {
          background standard_color
        }
      }

      color = @label.widget.getBackground
      swt_color_constant = org.eclipse.swt.SWT.const_get(standard_color.to_s.upcase.to_sym)
      expected_color = @target.display.getSystemColor(swt_color_constant)
      expect(color.getRed).to eq(expected_color.getRed)
      expect(color.getGreen).to eq(expected_color.getGreen)
      expect(color.getBlue).to eq(expected_color.getBlue)
      expect(color.getAlpha).to eq(expected_color.getAlpha)
    end
  end
end
