require('rails_helper')

RSpec.describe(UserAuth::AuthToken) do
  let(:id) { 1 }

  it('jwtをデコードする') do
    Timecop.freeze(Time.now)

    token = UserAuth::AuthToken.new(payload: { sub: id }).token
    payload = UserAuth::AuthToken.new(token: token).payload

    expect(payload['sub']).to eq(id)
    expect(payload['aud']).to eq(ENV['BACK_URL'])
    expect(payload['exp']).to eq(2.weeks.from_now.to_i)
  end
end
