require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  setup do
    Current.user = users(:one)
    @election = prepare_election
  end

  test 'audits create transaction of entity' do
    assert_difference('Audit.count') do
      @election.save
    end

    audit = newest_trail

    assert_equal({}, audit.data_changes)
    assert_equal(user.id, audit.user_id)
    assert_equal('create', audit.transaction_scope)

    assert_equal('Election', audit.auditable_type)
    assert_equal(@election.id, audit.auditable_id)
  end

  test 'does not trigger audit trail when entity dont receive data update' do
    @election.save

    assert_difference('Audit.count', 0) do
      @election.touch
    end
  end

  test 'audits when entity receive data update' do
    @election.save
    @election.name = 'Rails x Grape'

    assert_difference('Audit.count') do
      @election.save
    end

    audit = newest_trail

    assert_equal({'name' => ['Rails x Sinatra', 'Rails x Grape']}, audit.data_changes)
    assert_equal(user.id, audit.user_id)
    assert_equal('update', audit.transaction_scope)

    assert_equal('Election', audit.auditable_type)
    assert_equal(@election.id, audit.auditable_id)
  end

  private

  def prepare_election
    Election.new(
      name: 'Rails x Sinatra',
      start_at: Time.current,
      end_at: Time.current,
      user: Current.user,
      settings: { visibility: :public }
    )
  end

  def newest_trail
    Audit.last
  end

  def user
    Current.user
  end
end
