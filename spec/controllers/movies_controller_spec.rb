require 'spec_helper' 


describe MoviesController do
    
    let(:sw) {Movie.create!(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: '1977-05-25')}
    let(:br) {Movie.create!(title: 'Blade Runner', rating: 'PG', director: 'Ridley Scott', release_date: '1982-06-25')}
    let(:al) {Movie.create!(title: 'Alien', rating: 'R', release_date: '1979-05-25')}
    let(:thx) {Movie.create!(title: 'THX-1138', rating: 'R', director: 'George Lucas', release_date: '1971-03-11')}
    
    describe 'find movies with same director' do
        
        context 'when movie has director info' do
            it 'should call model method to find movies with same director' do
                Movie.any_instance.should_receive(:find_same_director_movies)
                get :search_by_director, id: sw
            end
            it 'should assign mvs with moves from same director' do
                Movie.any_instance.stub(:find_same_director_movies).and_return(thx)
                get :search_by_director, id: sw.to_param
                expect(assigns(:mvs)).to eq(thx)
            end
        end
        
        context 'when movie has no director info' do
            it 'should redirect_to the index page' do
                get :search_by_director, id: al.to_param
                expect(response).to redirect_to movies_path
            end
            it 'should include a notice saying that al has no director' do 
                get :search_by_director, id: al.to_param
                expect(flash[:notice]).to eq "'#{al.title}' has no director info"
            end
        end
    end
end