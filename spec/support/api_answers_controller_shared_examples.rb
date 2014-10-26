shared_examples 'api_answers_controller with incorrect params' do
  it 'should not update answer' do
    expect(ApiAnswerUpdater).not_to receive(:new)
    expect_any_instance_of(ApiAnswerUpdater).not_to receive(:perform!)
    call_request
  end

  context 'after call request' do
    before { call_request }

    it 'should display correct flash message' do
      expect(flash[:error]).to eq 'Secret is incorrect!'
    end

    it 'should redirect to root_path' do
      expect(response).to redirect_to root_path
    end
  end

  context 'when user logged in' do
    include_context 'user signed in'

    it 'should redirect to user_root_path' do
      call_request
      expect(response).to redirect_to user_root_path
    end
  end
end
