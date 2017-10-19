module ProgressBar
  @bar = ['','[']
  @bar.concat(10.times.map { |x| '    ' })
  @bar.concat([']',0,'%'])
  @prev = nil

  def self.progress(path, actual, max)
    progress = (percentage(actual,max)/10).truncate
    @bar[0] = path
    @bar[@bar.length-2] = percentage(actual,max)
    if @prev == nil
      emptyBar()
    elsif @prev != progress
      fillBar(progress)
    end
    print @bar.join('') + "\r"
    isFull()
  end
end

def percentage(actual, max)
  max != 0 ? (actual*100)/max : 100
end

def emptyBar()
  @prev = 0
  @bar.fill('    ', 2, @bar.length-5)
end

def fillBar(progress)
  @prev = progress
  @bar.fill('====', 2, progress-1)
  @bar[progress+1] = '===>'
end

def isFull()
  if @prev == 10
    @prev = nil
    print "\n"
  end
end

