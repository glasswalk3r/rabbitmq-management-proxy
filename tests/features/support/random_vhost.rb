module RandomVhost
    def random_vhost
        candidates = Array.new

        File.foreach('./vhosts.txt') do |line|
            if line.count('/') == 1
                candidates.push(line.chomp)
            end
        end

        random = Random.new
        candidates[random.rand(0..(candidates.size - 1))]
    end
end

World(RandomVhost)
