module Elections::AuditsHelper
  def render_audit(audit)
    render partial: 'audit_register', locals: { audit: audit}
  end

  def create_sentence(audit)
    "[#{occurrence_format(audit.created_at)}] #{audit.auditable_type} was created by #{audit.user.id}"
  end

  def update_sentence(audit, attribute, older_value, newer_value)
    "[#{occurrence_format(audit.created_at)}] #{attribute} of #{audit.auditable_type} was changed from #{older_value} to #{newer_value} by #{audit.user.id}"
  end

  def occurrence_format(created_at)
    created_at.to_formatted_s(:short)
  end
end
