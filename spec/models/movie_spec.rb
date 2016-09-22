require 'spec_helper' 

describe Movie do
    
    let(:sw) {Movie.create!(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: '1977-05-25')}
    let(:br) {Movie.create!(title: 'Blade Runner', rating: 'PG', director: 'Ridley Scott', release_date: '1982-06-25')}
    let(:al) {Movie.create!(title: 'Alien', rating: 'R', release_date: '1979-05-25')}
    let(:thx) {Movie.create!(title: 'THX-1138', rating: 'R', director: 'George Lucas', release_date: '1971-03-11')}
    
    describe 'find_same_director_movies' do
        it 'should select all movies with the same director as curr_movie' do
            expect(sw.find_same_director_movies).to eq [thx]
        end
        
        it 'should select no movies if no same director' do
            expect(br.find_same_director_movies).to eq []
        end
        
    end
end