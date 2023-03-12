require 'yaml'

class Interface
  def initialize
    @image = Gosu::Image.new("../sprite/life.png")
  end

  def draw(lifeRemaining)
    $x =1600
    (lifeRemaining-1).times do
      @image.draw($x, 142, 20, 4, 4)
      $x += 40
    end
  end

  def update_score(score)
    # Chargement du fichier YAML contenant le score
    yaml_data = YAML.safe.load_file('../hScore/hscore.yaml')

    # Comparaison du score avec le score du fichier YAML
    if score > yaml_data['hight_score']
      # Mise à jour du score dans le fichier YAML
      yaml_data['hight_score'] = score
      File.open('../hScore/hscore.yaml', 'w') do |file|
        file.write(yaml_data.to_yaml)
      end
    end
  end

end
