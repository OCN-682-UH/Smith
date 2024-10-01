##### Templates for ggplot from R4DS


### template for ggplot
ggplot(data = <DATA>) + 
<GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))



ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
    mapping = aes(<MAPPINGS>),
    stat = <STAT>, 
    position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>