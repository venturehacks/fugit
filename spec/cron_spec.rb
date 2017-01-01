
#
# Specifying fugit
#
# Sun Jan  1 16:40:00 JST 2017  Ishinomaki
#

require 'spec_helper'


describe Fugit::Cron do

  describe '.parse' do

    it 'parses @reboot'

    context 'success' do

      [

        [ '@yearly', '0 0 1 1 *' ],
        [ '@annually', '0 0 1 1 *' ],
        [ '@monthly', '0 0 1 * *' ],
        [ '@weekly', '0 0 * * 0' ],
        [ '@daily', '0 0 * * *' ],
        [ '@midnight', '0 0 * * *' ],
        [ '@hourly', '0 * * * *' ],

        [ '5 0 * * *', '5 0 * * *' ],
          # 5 minutes after midnight, every day
        [ '15 14 1 * *', '15 14 1 * *' ],
          # at 1415 on the 1st of every month
        [ '0 22 * * 1-5', '0 22 * * 1,2,3,4,5' ],
          # at 2200 on weekdays
        [ '23 0-23/2 * * *', '23 0,2,4,6,8,10,12,14,16,18,20,22 * * *' ],
          # 23 minutes after midnight, 0200, 0400, ...
        #[ '5 4 * * sun', :xxx ],
          # 0405 every sunday

        [ '14,24 8-12,14-19/2 * * *', '14,24 8,9,10,11,12,14,16,18 * * *' ],

        [ '*/1 1-3/1 * * *', '* 1,2,3 * * *' ],

      ].each do |cron, expected|

        it "parses #{cron}" do

          c = Fugit::Cron.parse(cron)

          expect(c.to_cron_s).to eq(expected)
        end
      end
    end

    context 'failure' do

      [
        '* 25 * * *'
      ].each do |cron|

        it "rejects #{cron}" do

          expect {
            Fugit::Cron.parse(cron)
          }.to raise_error(
            ArgumentError, "couldn't parse #{cron.inspect}"
          )
        end
      end
    end
  end
end

